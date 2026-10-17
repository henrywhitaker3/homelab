// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "talos_image_factory_extensions_versions" "this" {
  filters = {
    names = [
      "siderolabs/i915-ucode",
      "siderolabs/intel-ucode",
      "qemu-quest-agent",
      "iscsi-tools",
      "util-linux-tools",
    ]
  }
  talos_version = "v1.14.3"
}
resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info[*].name
      }
    }
  })
}
data "talos_image_factory_urls" "this" {
  platform      = "nocloud"
  schematic_id  = talos_image_factory_schematic.this.id
  talos_version = "v1.14.3"
}
resource "proxmox_storage_iso" "this" {
  filename = "talos-mango-${talos_image_factory_schematic.this.id}-v1.14.3.iso"
  for_each = toset([
    "proxmox-01",
    "proxmox-02",
    "proxmox-03",
  ])
  pve_node = each.value
  storage  = "local"
  url      = data.talos_image_factory_urls.this.urls.iso
  lifecycle {
    ignore_changes = [
      url,
      filename,
    ]
  }
}
resource "proxmox_vm_qemu" "this" {
  agent = 0
  for_each = {
    control-1 = {
      cpus = 4
      disks = {
        openebs = {
          size = "50Gi"
        }
      }
      ip          = "10.0.0.30"
      mac_address = "18:2f:a3:3e:dc:7a"
      memory      = 6114
      node        = 2
      type        = "controlplane"
    }
  }
  memory = each.value.memory
  name = format("talos-mango-%s-%d", each.value.type, index([
    "control-1",
  ], each.key) + 1)
  power_state        = "running"
  qemu_os            = "l26"
  scsihw             = "virtio-scsi-pci"
  start_at_node_boot = true
  tags = join(";", concat(lookup(each.value, "tags", [
    ]), [
    "talos",
    "mango",
    each.value.type,
  ]))
  target_node = [
    "proxmox-01",
    "proxmox-02",
    "proxmox-03",
  ][each.value.node - 1]
  cpu {
    cores   = each.value.cpus
    sockets = "1"
    type    = "host"
  }
  disk {
    iso = format("local:iso/%s", proxmox_storage_iso.this[[
      "proxmox-01",
      "proxmox-02",
      "proxmox-03",
    ][each.value.node - 1]].filename)
    slot = "ide2"
    type = "cdrom"
  }
  disk {
    format  = "raw"
    size    = 30
    slot    = "scsi0"
    storage = lookup(each.value, "storage", "local-lvm")
    type    = "disk"
  }
  dynamic "disk" {
    for_each = values(lookup(each.value, "disks", {}))
    content {
      format  = "raw"
      size    = trimsuffix(disk.value.size, "i")
      slot    = format("scsi%d", disk.key + 1)
      storage = lookup(disk.value, "storage", "local-lvm")
      type    = "disk"
    }
  }
  network {
    bridge  = lookup(each.value, "network_bridge", "vmbr0")
    id      = "1"
    macaddr = each.value.mac_address
    model   = "virtio"
  }
  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
}
resource "talos_machine_secrets" "this" {
  talos_version = "v1.14.3"
}
ephemeral "talos_cluster_kubeconfig" "upgrade" {
  cluster_name    = "mango"
  endpoint        = "https://10.0.0.8:6443"
  machine_secrets = talos_machine_secrets.this.machine_secrets
}
locals {
  patches = concat([
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "UnattendedInstallConfig"
      installer = {
        image = data.talos_image_factory_urls.this.urls.installer
      }
      provisioning = {
        diskSelector = {
          match = "disk.dev_path == \"/dev/sda\""
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeNetworkConfig"
      podSubnets = [
        "10.69.0.0/16",
      ]
      serviceSubnets = [
        "10.96.0.0/16",
      ]
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeNodeConfig"
      labels = {
        "topology.kubernetes.io/region" = "mango"
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ResolverConfig"
      nameservers = [
        {
          address = "1.1.1.1"
        },
        {
          address = "8.8.8.8"
        },
      ]
    }),
    ], "none" == "none" ? [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeFlannelCNIConfig"
      "$patch"   = "delete"
    }),
    ] : [
  ])
}
data "talos_machine_configuration" "node_control-1" {
  cluster_endpoint = "https://10.0.0.8:6443"
  cluster_name     = "mango"
  config_patches = concat(local.patches, [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeNodeConfig"
      labels = {
        "topology.kubernetes.io/zone" = 2
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "LinkAliasConfig"
      name       = "net0"
      selector = {
        match = "mac(link.permanent_addr) == \"18:2f:a3:3e:dc:7a\""
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "LinkConfig"
      name       = "net0"
      mtu        = 1500
      routes = [
      ]
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "DHCPv4Config"
      name       = "net0"
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "HostnameConfig"
      hostname   = "talos-mango-controlplane-1"
      auto       = "off"
    }),
    yamlencode({
      machine = {
        files = [
          {
            op      = "create"
            path    = "/etc/cri/conf.d/20-customization.part"
            content = <<-EOT
[plugins."io.containerd.grpc.v1.cri"]
  enable_unprivileged_ports = true
  enable_unprivileged_icmp = true
[plugins."io.containerd.grpc.v1.cri".containerd]
  discard_unpacked_layers = false
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  discard_unpacked_layers = false
EOT

            permissions = 0
          },
        ]
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeletConfig"
      extraArgs = {
        "rotate-server-certificates" = "true"
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
    ], "controlplane" != "controlplane" ? [
    ] : [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "Layer2VIPConfig"
      name       = "10.0.0.8"
      link       = "net0"
    }),
    ], [for disk_name, disk in {
      openebs = {
        filesystem = "ext4"
        mountpoint = "/var/mnt/openebs"
        selector   = "disk.size == 50u * GiB && !system_disk"
        size       = "50Gi"
      }
      } : yamlencode({
        apiVersion = "v1alpha1"
        kind       = "UserVolumeConfig"
        name       = disk_name
        provisioning = {
          diskSelector = {
            match = disk.selector
          }
          minSize = disk.size
          maxSize = disk.size
        }
        filesystem = {
          type = disk.filesystem
        }
    })], [
    ], [
    ], "controlplane" != "controlplane" ? [
    ] : [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeNodeConfig"
      taints = {
        "node-role.kubernetes.io/control-plane" = {
          "$patch" = "delete"
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeControllerManagerConfig"
      extraArgs = {
        "bind-address" = "0.0.0.0"
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeCoreDNSConfig"
      enabled    = false
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeProxyConfig"
      enabled    = "none" != "none"
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeSchedulerConfig"
      extraArgs = {
        "bind-address" = "0.0.0.0"
      }
    }),
    yamlencode({
      cluster = {
        etcd = {
          extraArgs = {
            "listen-metrics-urls" = "http://0.0.0.0:2381"
          }
        }
      }
    }),
    yamlencode({
      machine = {
        features = {
          kubernetesTalosAPIAccess = {
            enabled = true
            allowedRoles = [
              "os:admin",
            ]
            allowedKubernetesNamespaces = [
              "system-upgrades",
            ]
          }
        }
      }
    }),
  ])
  kubernetes_version = "v1.37.1"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "controlplane"
  talos_version      = "v1.14.3"
}
resource "talos_machine" "node_control-1" {
  client_configuration = talos_machine_secrets.this.client_configuration
  depends_on = [
    proxmox_vm_qemu.this,
  ]
  ignore_kubernetes_upgrade_drift = true
  image                           = data.talos_image_factory_urls.this.urls.installer
  kubeconfig_wo                   = ephemeral.talos_cluster_kubeconfig.upgrade.kubeconfig_raw
  machine_configuration           = data.talos_machine_configuration.node_control-1.machine_configuration
  node                            = "10.0.0.30"
}
resource "talos_cluster" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes = [
    "10.0.0.30",
  ]
  depends_on = [
    talos_machine.node_control-1,
  ]
  kubernetes_version = "v1.37.1"
  node               = "10.0.0.30"
}
locals {
  bootstrap_hash = "e56b4c9fe3a55193734c00fbe601baa45dbce361e149893408e19764f365f874"
  helmfile_hash  = "24409776f970cdabb57dc00151758ddf91df11c4b836101c8d2b51eab659b1ff"
}
resource "terraform_data" "sleep" {
  depends_on = [
    talos_cluster.this,
  ]
  triggers_replace = [
    local.helmfile_hash,
  ]
  provisioner "local-exec" {
    command = "sleep 15"
  }
}
resource "terraform_data" "bootstrap_cni" {
  depends_on = [
    terraform_data.sleep,
  ]
  triggers_replace = [
    local.helmfile_hash,
  ]
  provisioner "local-exec" {
    command = <<-EOT
set -eu
kubeconfig="$(mktemp)"
trap 'rm -f "$kubeconfig"' EXIT
printf '%s' "$KUBECONFIG_RAW" > "$kubeconfig"
export KUBECONFIG="$kubeconfig"
helmfile apply --skip-diff-on-install --suppress-diff
EOT

    environment = {
      KUBECONFIG_RAW = ephemeral.talos_cluster_kubeconfig.upgrade.kubeconfig_raw
    }
    interpreter = [
      "/bin/sh",
      "-c",
    ]
    quiet       = true
    working_dir = "../../kubernetes/mango/bootstrap/talos/apps"
  }
}
resource "terraform_data" "bootstrap_argo" {
  depends_on = [
    terraform_data.bootstrap_cni,
  ]
  triggers_replace = [
    local.bootstrap_hash,
  ]
  provisioner "local-exec" {
    command = <<-EOT
set -eu
kubeconfig="$(mktemp)"
trap 'rm -f "$kubeconfig"' EXIT
printf '%s' "$KUBECONFIG_RAW" > "$kubeconfig"
export KUBECONFIG="$kubeconfig"
current_context="$(kubectl config current-context)"
if [ "$current_context" != "$CLUSTER_NAME" ]; then
  kubectl config rename-context "$current_context" "$CLUSTER_NAME"
fi
task argo:repo
task argo:bootstrap "cluster=$CLUSTER_NAME"
EOT

    environment = {
      KUBECONFIG_RAW = ephemeral.talos_cluster_kubeconfig.upgrade.kubeconfig_raw
      CLUSTER_NAME   = "mango"
    }
    interpreter = [
      "/bin/sh",
      "-c",
    ]
    quiet       = true
    working_dir = "../../"
  }
}
resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  depends_on = [
    talos_cluster.this,
  ]
  node = "10.0.0.8"
}
output "talos_kubeconfig" {
  description = "The kubeconfig of the talos cluster"
  sensitive   = true
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
}
