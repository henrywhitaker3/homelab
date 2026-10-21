globals "talos" {
  name = "mango"
  # renovate: datasource=github-releases depName=siderolabs/talos
  version = "v1.14.4"
  # renovate: datasource=github-releases depName=kubernetes/kubernetes
  kubernetes_version = "v1.37.1"

  control_plane_ip = "10.0.0.8"
  network_prefix   = 24
  network_gateway  = "10.0.0.1"

  registry_mirrors = {
    "docker.io" = {
      endpoints = [{
        url          = "https://harbor.plexmox.com/v2/docker.io"
        overridePath = true
      }]
    }
    "ghcr.io" = {
      endpoints = [{
        url          = "https://harbor.plexmox.com/v2/ghcr.io"
        overridePath = true
      }]
    }
  }

  nodes = {
    control-1 = {
      node   = 1
      cpus   = 7
      memory = 24576
      type   = "controlplane"
      ip     = "10.0.0.30"
      disks = {
        longhorn = {
          size = "500Gi"
        }
        openebs = {
          size = "100Gi"
        }
      }
    },
    control-2 = {
      node   = 2
      cpus   = 7
      memory = 24576
      type   = "controlplane"
      ip     = "10.0.0.31"
      disks = {
        longhorn = {
          size = "500Gi"
        }
        openebs = {
          size = "100Gi"
        }
      }
    },
    control-3 = {
      node   = 3
      cpus   = 7
      memory = 24576
      type   = "controlplane"
      ip     = "10.0.0.32"
      disks = {
        longhorn = {
          size = "500Gi"
        }
        openebs = {
          size = "100Gi"
        }
      }
    }
    worker-1 = {
      vm                = false
      ip                = "10.0.0.33"
      type              = "worker"
      network_interface = "enp3s0"
      disks = {
        longhorn = {
          size          = "160Gi"
          disk_selector = "disk.transport == \"nvme\" && !system_disk"
        }
        openebs = {
          size          = "80Gi"
          disk_selector = "disk.transport == \"nvme\" && !system_disk"
        }
      }
    }
  }
}
