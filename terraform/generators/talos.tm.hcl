generate_hcl "generated_talos.tf" {
  condition = tm_contains(terramate.stack.tags, "talos")

  lets {
    name = tm_try(global.talos.name, terramate.stack.name)

    talos_version      = tm_try(global.talos.version, null)
    kubernetes_version = tm_try(global.talos.kubernetes_version, null)
    image_filters = tm_try(global.talos.image_filters, [
      "siderolabs/i915-ucode",
      "siderolabs/intel-ucode",
      "qemu-quest-agent",
      "iscsi-tools",
      "util-linux-tools",
    ])

    control_plane_ip = tm_try(global.talos.control_plane_ip, null)
    nodes            = tm_try(global.talos.nodes, {})
    node_keys        = tm_sort(tm_keys(let.nodes))
    node_disks = {
      for node_name, node in let.nodes : node_name => {
        for disk_name in tm_sort(tm_keys(tm_try(node.disks, {}))) : disk_name => {
          filesystem = tm_try(node.disks[disk_name].filesystem, "ext4")
          mountpoint = tm_try(node.disks[disk_name].mountpoint, tm_format("/var/mnt/%s", disk_name))
          selector = tm_try(
            node.disks[disk_name].disk_selector,
            tm_format(
              "disk.size == %su * GiB && !system_disk",
              tm_trimsuffix(node.disks[disk_name].size, "Gi"),
            ),
          )
          size = node.disks[disk_name].size
        }
      }
    }
    routes  = tm_try(global.talos.routes, [])
    patches = tm_try(global.talos.patches, [])

    cluster_service_cidr = tm_try(global.talos.cluster_service_cidr, "10.96.0.0/16")
    cluster_pod_cidr     = tm_try(global.talos.cluster_pod_cidr, "10.69.0.0/16")
    cluster_cni          = tm_try(global.talos.cluster_cni, "none")
    nameservers          = tm_try(global.talos.nameservers, ["1.1.1.1", "8.8.8.8"])

    proxmox_nodes = tm_try(global.talos.proxmox_nodes, ["proxmox-01", "proxmox-02", "proxmox-03"])
    iso_storage   = tm_try(global.talos.iso_storage, "local")
  }

  assert {
    assertion = let.name != null
    message   = "global.talos.name must be set"
  }

  assert {
    assertion = let.talos_version != null
    message   = "global.talos.version must be set"
  }

  assert {
    assertion = let.kubernetes_version != null
    message   = "global.talos.kubernetes_version must be set"
  }

  assert {
    assertion = let.control_plane_ip != null
    message   = "global.talos.control_plane_ip must be set"
  }

  assert {
    assertion = tm_length(tm_keys(let.nodes)) >= 1
    message   = "Must provide at least 1 node"
  }

  assert {
    assertion = tm_length([for node in tm_values(let.nodes) : node if node.type == "controlplane"]) >= 1
    message   = "Must provide at least 1 controlplane node"
  }

  assert {
    assertion = tm_alltrue(tm_flatten([
      for disks in tm_values(let.node_disks) : [
        for disk_name, disk in disks : disk.mountpoint == tm_format("/var/mnt/%s", disk_name)
      ]
    ]))
    message = "Talos user volumes must use /var/mnt/<disk name> as their mountpoint"
  }

  content {
    data "talos_image_factory_extensions_versions" "this" {
      talos_version = let.talos_version
      filters = {
        names = let.image_filters
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

    data "talos_image_factory_urls" "this" {
      platform      = "nocloud"
      schematic_id  = talos_image_factory_schematic.this.id
      talos_version = let.talos_version
    }

    resource "proxmox_storage_iso" "this" {
      for_each = toset(let.proxmox_nodes)
      url      = data.talos_image_factory_urls.this.urls.iso
      filename = "talos-${let.name}-${talos_image_factory_schematic.this.id}-${let.talos_version}.iso"
      storage  = let.iso_storage
      pve_node = each.value

      lifecycle {
        ignore_changes = [url, filename]
      }
    }

    resource "proxmox_vm_qemu" "this" {
      for_each = {
        for index, node in let.nodes : index => node
      }

      name               = format("talos-${let.name}-%s-%d", each.value.type, index(let.node_keys, each.key) + 1)
      target_node        = let.proxmox_nodes[each.value.node - 1]
      agent              = 0
      memory             = each.value.memory
      start_at_node_boot = true
      scsihw             = "virtio-scsi-pci"
      qemu_os            = "l26"
      power_state        = "running"

      cpu {
        cores   = each.value.cpus
        type    = "host"
        sockets = "1"
      }

      disk {
        type = "cdrom"
        slot = "ide2"
        iso  = format("local:iso/%s", proxmox_storage_iso.this[let.proxmox_nodes[each.value.node - 1]].filename)
      }

      disk {
        type    = "disk"
        slot    = "scsi0"
        storage = lookup(each.value, "storage", "local-lvm")
        size    = 30
        format  = "raw"
      }

      dynamic "disk" {
        for_each = values(lookup(each.value, "disks", {}))

        content {
          type    = "disk"
          slot    = format("scsi%d", disk.key + 1)
          storage = lookup(disk.value, "storage", "local-lvm")
          size    = trimsuffix(disk.value.size, "i")
          format  = "raw"
        }
      }

      network {
        id      = "1"
        model   = "virtio"
        bridge  = lookup(each.value, "network_bridge", "vmbr0")
        macaddr = each.value.mac_address
      }

      startup_shutdown {
        order            = -1
        shutdown_timeout = -1
        startup_delay    = -1
      }

      tags = join(";", concat(lookup(each.value, "tags", []), ["talos", let.name, each.value.type]))
    }

    resource "talos_machine_secrets" "this" {
      talos_version = let.talos_version
    }

    ephemeral "talos_cluster_kubeconfig" "upgrade" {
      cluster_name    = let.name
      endpoint        = "https://${let.control_plane_ip}:6443"
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
          apiVersion     = "v1alpha1"
          kind           = "KubeNetworkConfig"
          podSubnets     = [let.cluster_pod_cidr]
          serviceSubnets = [let.cluster_service_cidr]
        }),
        yamlencode({
          apiVersion = "v1alpha1"
          kind       = "KubeNodeConfig"
          labels = {
            "topology.kubernetes.io/region" = let.name
          }
        }),
        yamlencode({
          apiVersion = "v1alpha1"
          kind       = "ResolverConfig"
          nameservers = [
            for nameserver in let.nameservers : {
              address = nameserver
            }
          ]
        }),
        ], let.cluster_cni == "none" ? [
        yamlencode({
          apiVersion = "v1alpha1"
          kind       = "KubeFlannelCNIConfig"
          "$patch"   = "delete"
        }),
      ] : [])
    }

    tm_dynamic "data" {
      for_each = let.node_keys
      iterator = node
      labels   = ["talos_machine_configuration", "node_${node.value}"]

      content {
        cluster_name       = let.name
        machine_type       = let.nodes[node.value].type
        cluster_endpoint   = "https://${let.control_plane_ip}:6443"
        machine_secrets    = talos_machine_secrets.this.machine_secrets
        kubernetes_version = let.kubernetes_version
        talos_version      = let.talos_version
        config_patches = concat(
          local.patches,
          [
            yamlencode({
              apiVersion = "v1alpha1"
              kind       = "KubeNodeConfig"
              labels = {
                "topology.kubernetes.io/zone" = let.nodes[node.value].node
              }
            }),
            yamlencode({
              apiVersion = "v1alpha1"
              kind       = "LinkAliasConfig"
              name       = "net0"
              selector = {
                match = tm_format("mac(link.permanent_addr) == \"%s\"", let.nodes[node.value].mac_address)
              }
            }),
            yamlencode({
              apiVersion = "v1alpha1"
              kind       = "LinkConfig"
              name       = "net0"
              mtu        = 1500
              routes = [
                for route in let.routes : {
                  destination = route.network
                  gateway     = route.gateway
                }
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
              hostname   = tm_format("talos-%s-%s-%d", let.name, let.nodes[node.value].type, node.key + 1)
              auto       = "off"
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
          ],
          let.nodes[node.value].type != "controlplane" ? [] : [
            yamlencode({
              apiVersion = "v1alpha1"
              kind       = "Layer2VIPConfig"
              name       = let.control_plane_ip
              link       = "net0"
            }),
          ],
          [
            for disk_name, disk in let.node_disks[node.value] : yamlencode({
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
            })
          ],
          [
            for patch in tm_try(let.nodes[node.value].patches, []) : yamlencode(patch)
          ],
          [
            for patch in let.patches : yamlencode(patch)
          ],
          let.nodes[node.value].type != "controlplane" ? [] : [
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
              enabled    = let.cluster_cni != "none"
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
                    enabled                     = true
                    allowedRoles                = ["os:admin"]
                    allowedKubernetesNamespaces = ["system-upgrades"]
                  }
                }
              }
            }),
          ],
        )
      }
    }

    tm_dynamic "resource" {
      for_each = tm_slice(let.node_keys, 0, 1)
      iterator = node
      labels   = ["talos_machine", "node_${node.value}"]

      content {
        client_configuration            = talos_machine_secrets.this.client_configuration
        ignore_kubernetes_upgrade_drift = true
        image                           = data.talos_image_factory_urls.this.urls.installer
        kubeconfig_wo                   = ephemeral.talos_cluster_kubeconfig.upgrade.kubeconfig_raw
        machine_configuration           = tm_hcl_expression("data.talos_machine_configuration.node_${node.value}.machine_configuration")
        node                            = let.nodes[node.value].ip

        depends_on = [
          proxmox_vm_qemu.this,
        ]
      }
    }

    tm_dynamic "resource" {
      for_each = tm_slice(let.node_keys, 1, tm_length(let.node_keys))
      iterator = node
      labels   = ["talos_machine", "node_${node.value}"]

      content {
        client_configuration            = talos_machine_secrets.this.client_configuration
        ignore_kubernetes_upgrade_drift = true
        image                           = data.talos_image_factory_urls.this.urls.installer
        kubeconfig_wo                   = ephemeral.talos_cluster_kubeconfig.upgrade.kubeconfig_raw
        machine_configuration           = tm_hcl_expression("data.talos_machine_configuration.node_${node.value}.machine_configuration")
        node                            = let.nodes[node.value].ip

        depends_on = [
          proxmox_vm_qemu.this,
          tm_hcl_expression("talos_machine.node_${let.node_keys[tm_index(let.node_keys, node.value) - 1]}")
        ]
      }
    }

    resource "talos_cluster" "this" {
      node                 = [for key in let.node_keys : let.nodes[key].ip if let.nodes[key].type == "controlplane"][0]
      client_configuration = talos_machine_secrets.this.client_configuration
      control_plane_nodes = [
        for key in let.node_keys : let.nodes[key].ip if let.nodes[key].type == "controlplane"
      ]
      kubernetes_version = let.kubernetes_version

      depends_on = [
        for key in let.node_keys : tm_hcl_expression("talos_machine.node_${key}")
      ]
    }

    locals {
      helmfile_hash = tm_filesha256("../../kubernetes/${let.name}/bootstrap/talos/apps/helmfile.yaml")
      bootstrap_hash = tm_sha256(tm_jsonencode({
        for file in tm_fileset("../../kubernetes/${let.name}/bootstrap", "**") :
        file => tm_filesha256("../../kubernetes/${let.name}/bootstrap/${file}")
      }))
    }

    # Wait for the arp to propogate api IP
    resource "terraform_data" "sleep" {
      triggers_replace = [local.helmfile_hash]

      provisioner "local-exec" {
        command = "sleep 15"
      }

      depends_on = [talos_cluster.this]
    }

    resource "terraform_data" "bootstrap_cni" {
      triggers_replace = [local.helmfile_hash]

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

        interpreter = ["/bin/sh", "-c"]
        quiet       = true
        working_dir = tm_format("../../kubernetes/%s/bootstrap/talos/apps", let.name)
      }

      depends_on = [terraform_data.sleep]
    }

    resource "terraform_data" "bootstrap_argo" {
      triggers_replace = [local.bootstrap_hash]

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
          CLUSTER_NAME   = let.name
        }

        interpreter = ["/bin/sh", "-c"]
        quiet       = true
        working_dir = "../../"
      }

      depends_on = [terraform_data.bootstrap_cni]
    }

    resource "talos_cluster_kubeconfig" "this" {
      depends_on = [
        talos_cluster.this
      ]
      client_configuration = talos_machine_secrets.this.client_configuration
      node                 = let.control_plane_ip
    }

    output "talos_kubeconfig" {
      description = "The kubeconfig of the talos cluster"
      sensitive   = true
      value       = talos_cluster_kubeconfig.this.kubeconfig_raw
    }

    # data "talos_cluster_health" "this" {
    #   client_configuration = talos_machine_secrets.this.client_configuration
    #   control_plane_nodes = [
    #     for key in let.node_keys : let.nodes[key].ip if let.nodes[key].type == "controlplane"
    #   ]
    #   endpoints = [
    #     for key in let.node_keys : let.nodes[key].ip if let.nodes[key].type == "controlplane"
    #   ]
    #   worker_nodes = [
    #     for key in let.node_keys : let.nodes[key].ip if let.nodes[key].type == "worker"
    #   ]
    #
    #   depends_on = [talos_cluster.this]
    # }
  }
}
