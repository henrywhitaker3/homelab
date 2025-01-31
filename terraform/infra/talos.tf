locals {
  talos_clusters = {
    # mango = {
    #   version            = "v1.9.3"
    #   kubernetes_version = "v1.32.1"
    #   image_filters = [
    #     "siderolabs/i915-ucode",
    #     "siderolabs/intel-ucode",
    #     "qemu-quest-agent",
    #     "iscsi-tools",
    #     "util-linux-tools",
    #   ]
    #   control_plane_ip = "10.0.0.8"
    #   kubeconfig_file  = "~/.kube/mango"
    #   helmfile         = "../../kubernetes/mango/bootstrap/talos/apps/helmfile.yaml"
    #   routes = [
    #     {
    #       network = "10.8.0.0/24"
    #       gateway = "10.0.0.13"
    #     },
    #     {
    #       network = "0.0.0.0/0"
    #       gateway = "10.0.0.1"
    #     }
    #   ]
    #   nodes = [
    #     {
    #       node        = 1
    #       cpus        = 2
    #       memory      = 2048
    #       type        = "controlplane"
    #       ip          = "10.0.0.30"
    #       mac_address = "18:2f:a3:3e:dc:7a"
    #     },
    #     {
    #       node        = 2
    #       cpus        = 2
    #       memory      = 2048
    #       type        = "controlplane"
    #       ip          = "10.0.0.31"
    #       mac_address = "18:88:df:e6:c2:99"
    #     },
    #     {
    #       node        = 3
    #       cpus        = 2
    #       memory      = 2048
    #       type        = "controlplane"
    #       ip          = "10.0.0.32"
    #       mac_address = "18:e7:3e:fa:e1:f9"
    #     }
    #   ]
    #}
  }
}

module "talos" {
  source = "./talos"

  for_each = local.talos_clusters

  control_plane_ip    = each.value.control_plane_ip
  cluster_name        = each.key
  kubernetes_version  = each.value.kubernetes_version
  talos_version       = each.value.version
  talos_image_filters = each.value.image_filters
  nodes               = each.value.nodes
  routes              = each.value.routes
  kubeconfig_file     = each.value.kubeconfig_file
  helmfile            = lookup(each.value, "helmfile", null)
}
