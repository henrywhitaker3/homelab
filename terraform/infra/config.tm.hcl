globals "talos" {
  name = "mango"
  # renovate: datasource=github-releases depName=siderolabs/talos
  version = "v1.14.3"
  # renovate: datasource=github-releases depName=kubernetes/kubernetes
  kubernetes_version = "v1.37.1"

  control_plane_ip = "10.0.0.8"

  nodes = {
    control-1 = {
      node        = 1
      cpus        = 2
      memory      = 4096
      type        = "controlplane"
      ip          = "10.0.0.30"
      mac_address = "18:2f:a3:3e:dc:7a"
      disks = {
        longhorn = {
          size       = "500Gi"
          mountpoint = "/var/lib/longhorn"
        }
        openebs = {
          size       = "100Gi"
          mountpoint = "/var/openebs/local"
        }
      }
    },
    control-2 = {
      node        = 2
      cpus        = 2
      memory      = 4096
      type        = "controlplane"
      ip          = "10.0.0.31"
      mac_address = "18:88:df:e6:c2:99"
      disks = {
        longhorn = {
          size       = "500Gi"
          mountpoint = "/var/lib/longhorn"
        }
        openebs = {
          size       = "100Gi"
          mountpoint = "/var/openebs/local"
        }
      }
    },
    control-3 = {
      node        = 3
      cpus        = 2
      memory      = 4096
      type        = "controlplane"
      ip          = "10.0.0.32"
      mac_address = "18:e7:3e:fa:e1:f9"
      disks = {
        longhorn = {
          size       = "500Gi"
          mountpoint = "/var/lib/longhorn"
        }
        openebs = {
          size       = "100Gi"
          mountpoint = "/var/openebs/local"
        }
      }
    }
  }
}
