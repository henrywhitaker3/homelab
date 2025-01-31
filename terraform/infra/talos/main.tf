data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = var.talos_image_filters
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

resource "proxmox_storage_iso" "this" {
  for_each = toset(var.proxmox_nodes)
  url      = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.iso"
  filename = "talos-${var.cluster_name}-${talos_image_factory_schematic.this.id}-${var.talos_version}.iso"
  storage  = var.iso_storage
  pve_node = each.value
}

resource "proxmox_vm_qemu" "this" {
  for_each = {
    for index, node in var.nodes : index => node
  }

  name        = "talos-${var.cluster_name}-${each.value.type}-${each.key + 1}"
  target_node = var.proxmox_nodes[each.value.node - 1]
  agent       = 0
  cores       = each.value.cpus
  memory      = each.value.memory
  onboot      = true
  scsihw      = "virtio-scsi-pci"
  qemu_os     = "l26"
  vm_state    = "running"

  disks {
    ide {
      ide2 {
        cdrom {
          iso = format("local:iso/%s", proxmox_storage_iso.this[var.proxmox_nodes[each.value.node - 1]].filename)
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = lookup(each.value, "storage", "local-lvm")
          size    = 30
          format  = "raw"
        }
      }
      dynamic "scsi1" {
        for_each = {
          for index, disk in each.value.disks : index => disk
        }

        content {
          disk {
            storage = lookup(scsi1.value, "storage", "local-lvm")
            size    = scsi1.value.size
            format  = "raw"
          }
        }
      }
    }
  }

  network {
    model   = "virtio"
    bridge  = lookup(each.value, "network_bridge", "vmbr0")
    macaddr = each.value.mac_address
  }

  tags = join(";", concat(lookup(each.value, "tags", []), ["talos", var.cluster_name, each.value.type]))
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

locals {
  patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sda"
        }
      }
    }),
    yamlencode({
      cluster = {
        network = {
          podSubnets     = [var.cluster_pod_cidr]
          serviceSubnets = [var.cluster_service_cidr]
          cni = {
            name = var.cluster_cni
          }
        }
      }
    }),
    yamlencode({
      machine = {
        nodeLabels = {
          "topology.kubernetes.io/region" = var.cluster_name
        }
      }
    }),
    yamlencode({
      machine = {
        network = {
          nameservers = var.nameservers
        }
      }
    }),
  ]
}

data "talos_machine_configuration" "this" {
  for_each = {
    for index, node in var.nodes : index => node
  }

  cluster_name     = var.cluster_name
  machine_type     = each.value.type
  cluster_endpoint = format("https://%s:6443", var.control_plane_ip)
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = concat(
    local.patches,
    [
      yamlencode({
        machine = {
          nodeLabels = {
            "topology.kubernetes.io/zone" = each.value.node
          }
        }
      }),
      yamlencode({
        machine = {
          network = {
            interfaces = [
              {
                deviceSelector = {
                  hardwareAddr = each.value.mac_address
                }
                routes = var.routes
                vip = {
                  ip = var.control_plane_ip
                }
                mtu  = 1500
                dhcp = true
              }
            ]
          }
        }
      }),
      yamlencode({
        machine = {
          network = {
            hostname = format("talos-${var.cluster_name}-${each.value.type}-${each.key + 1}")
          }
        }
      }),
      yamlencode({
        machine = {
          files = [
            {
              op          = "create"
              path        = "/etc/cri/conf.d/20-customization.part"
              content     = <<-EOS
                [plugins."io.containerd.grpc.v1.cri"]
                  enable_unprivileged_ports = true
                  enable_unprivileged_icmp = true
                [plugins."io.containerd.grpc.v1.cri".containerd]
                  discard_unpacked_layers = false
                [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
                  discard_unpacked_layers = false
              EOS
              permissions = 0
            }
          ]
        }
      }),
      yamlencode({
        machine = {
          network = {
            disableSearchDomain = false
          }
        }
      }),
      yamlencode({
        machine = {
          kubelet = {
            extraArgs = {
              "rotate-server-certificates" = true
            }
          }
        }
      }),
      yamlencode({
        machine = {
          sysctls = {
            "fs.inotify.max_queued_events"  = "65536"
            "fs.inotify.max_user_watches"   = "524288"
            "fs.inotify.max_user_instances" = "8192"
            "net.core.rmem_max"             = "2500000"
            "net.core.wmem_max"             = "2500000"
          }
        }
      }),
    ],
    [
      for patch in lookup(each.value, "patches", []) : yamlencode(patch)
    ],
    [
      for patch in var.patches : yamlencode(patch)
    ],
    each.value.type != "controlplane" ? [] : [
      yamlencode({
        cluster = {
          allowSchedulingOnControlPlanes = true
          controllerManager = {
            extraArgs = {
              "bind-address" = "0.0.0.0"
            }
          }
          coreDNS = {
            disabled = true
          }
          proxy = {
            disabled = var.cluster_cni == "none" ? true : false
          }
          scheduler = {
            extraArgs = {
              "bind-address" = "0.0.0.0"
            }
          }
          etcd = {
            extraArgs = {
              "listen-metrics-urls" = "http://0.0.0.0:2381"
            }
          }
        }
      }),
      yamlencode([
        {
          op   = "remove"
          path = "/cluster/apiServer/admissionControl"
        }
      ]),
      yamlencode({
        machine = {
          features = {
            kubernetesTalosAPIAccess = {
              enabled                     = true
              allowedRoles                = ["os:admin"]
              allowedKubernetesNamespaces = ["system-upgrades"]
            }
          }
        }
      }),
    ]
  )
}

resource "talos_machine_configuration_apply" "this" {
  for_each = {
    for index, node in var.nodes : index => node
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.ip
  depends_on                  = [proxmox_vm_qemu.this]
}

resource "local_file" "machine_config" {
  for_each = {
    for index, node in var.nodes : index => node
  }
  content  = data.talos_machine_configuration.this[each.key].machine_configuration
  filename = format("/tmp/talos-${var.cluster_name}-${each.value.type}-${each.key + 1}.yaml")
}

resource "time_sleep" "apply" {
  depends_on = [talos_machine_configuration_apply.this]

  create_duration = "120s"
}

resource "talos_machine_bootstrap" "this" {
  node                 = var.nodes[0].ip
  client_configuration = talos_machine_secrets.this.client_configuration

  depends_on = [time_sleep.apply]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_ip

  depends_on = [
    talos_machine_bootstrap.this
  ]
}

resource "local_file" "kube_config" {
  filename        = pathexpand(var.kubeconfig_file)
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  file_permission = "0600"
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes = [
    for node in var.nodes : node.ip if node.type == "controlplane"
  ]
  endpoints = [
    for node in var.nodes : node.ip if node.type == "controlplane"
  ]
  worker_nodes = [
    for node in var.nodes : node.ip if node.type == "worker"
  ]
  depends_on = [talos_machine_bootstrap.this]
}

resource "null_resource" "helmfile" {
  count = var.helmfile != null ? 1 : 0
  provisioner "local-exec" {
    command = "helmfile --kubeconfig ${pathexpand(var.kubeconfig_file)} --file ${pathexpand(var.helmfile)} apply --skip-diff-on-install --suppress-diff"
  }
  depends_on = [data.talos_cluster_health.this]
}
