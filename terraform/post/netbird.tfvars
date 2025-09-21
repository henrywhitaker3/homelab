netbird_networks = {
  "home"   = {}
  "do-lon" = {}
}

netbird_setup_keys = {
  "jump" = {
    auto_groups = ["jump"]
  }
  "proxmox-01" = {
    auto_groups = ["proxmox"]
  }
  "proxmox-02" = {
    auto_groups = ["proxmox"]
  }
  "proxmox-03" = {
    auto_groups = ["proxmox"]
  }
}

netbird_groups = {
  "homelab" = {
    peers = [
      "adguard-1",
      "adguard-2",
      "k3s-control-1",
      "k3s-control-2",
      "k3s-control-3",
      "k3s-dedi-1",
      "lb-1",
      "lb-2",
      "minio-1",
      "minio-2",
      "proxmox-01",
      "proxmox-02",
      "proxmox-03",
    ]
  }
  "k3s" = {
    peers = [
      "k3s-control-1",
      "k3s-control-2",
      "k3s-control-3",
      "k3s-dedi-1",
    ]
  }
  "proxmox" = {
    peers = [
      "proxmox-01",
      "proxmox-02",
      "proxmox-03",
    ]
  }
  "devices" = {
    peers = ["phone", "mbp", "mac-mini", "tablet"]
  }
  "jump" = {
    peers = ["jump-k8s"]
  }
  "All" = {
    data = true
  }
}

netbird_routers = {
  "home" = {
    network     = "home"
    peer_groups = ["homelab"]
  }
  "do-lon" = {
    network     = "do-lon"
    peer_groups = ["jump"]
  }
}

netbird_peers = {
  "phone"      = {}
  "jump-k8s"   = {}
  "mbp"        = {}
  "mac-mini"   = {}
  "tablet"     = {}
  "proxmox-01" = {}
  "proxmox-02" = {}
  "proxmox-03" = {}
}

netbird_resources = {
  "external-ingress" = {
    network = "home"
    groups  = ["All", "homelab", "k3s"]
    address = "10.0.0.25/32"
  }
  "internal-ingress" = {
    network = "home"
    groups  = ["All", "homelab", "k3s"]
    address = "10.0.0.27/32"
  }
  "adguard-1" = {
    network = "home"
    groups  = ["All", "homelab"]
    address = "10.0.0.2/32"
  }
  "adguard-2" = {
    network = "home"
    groups  = ["All", "homelab"]
    address = "10.0.0.3/32"
  }
  "unraid" = {
    network = "home"
    groups  = ["All", "homelab"]
    address = "10.0.0.9/32"
  }
  "jetkvm" = {
    network = "home"
    groups  = ["All", "homelab"]
    address = "10.0.0.62/32"
  }
  # TODO: remove this when netbird allows macs to talk properly
  "mac-mini" = {
    network = "home"
    groups  = ["All"]
    address = "10.0.0.54/32"
  }
  "do-lon" = {
    network = "do-lon"
    groups  = ["All", "jump"]
    address = "10.100.0.0/24"
  }
}

netbird_nameservers = {
  "adguard-nameservers" = {
    description            = "Use adguard for plexmox domain"
    domains                = ["plexmox.com", "netbird.lab"]
    search_domains_enabled = true
    groups                 = ["jump", "devices"]
    nameservers = {
      adguard-1 = {
        ip = "10.0.0.2"
      }
      adguard-2 = {
        ip = "10.0.0.3"
      }
    }
  }
}

netbird_policies = {
  "allow-all-home-dns-adguard-1" = {
    description = "Allow all devieces to use dns on adguard-1"
    rule = {
      description          = "Allow all deviecs to use udp 53 to adguard-1"
      action               = "accept"
      protocol             = "udp"
      ports                = [53]
      sources              = ["All"]
      destination_resource = "adguard-1"
    }
  }
  "allow-all-home-dns-adguard-2" = {
    description = "Allow all devieces to use dns on adguard-2"
    rule = {
      description          = "Allow all deviecs to use udp 53 to adguard-2"
      action               = "accept"
      protocol             = "udp"
      ports                = [53]
      sources              = ["All"]
      destination_resource = "adguard-2"
    }
  }
  "devices-to-all" = {
    description = "Allow devices to access all groups"
    rule = {
      description  = "Allow all from devices -> all"
      action       = "accept"
      protocol     = "all"
      sources      = ["devices"]
      destinations = ["All"]
    }
  }
  "deviecs-to-devices" = {
    description = "Allow devices to talk to each other"
    rule = {
      description   = "Allow all ports from devices <-> devices"
      action        = "accept"
      protocol      = "all"
      sources       = ["devices"]
      destinations  = ["devices"]
      bidirectional = true
    }
  }
  "allow-jump-to-public-ingress" = {
    description = "Allow jump servers to access k8s ingress"
    rule = {
      action               = "accept"
      protocol             = "tcp"
      ports                = [80, 443]
      sources              = ["jump"]
      destination_resource = "external-ingress"
    }
  }
  "allow-jump-to-internal-ingress" = {
    description = "Allow access to internal-ingress"
    rule = {
      action               = "accept"
      protocol             = "tcp"
      ports                = [80, 443]
      sources              = ["jump"]
      destination_resource = "internal-ingress"
    }
  }
  "allow-k3s-to-jump-telemetry" = {
    description = "Allow home network to access jump telemtry"
    rule = {
      action   = "accept"
      protocol = "tcp"
      ports = [
        8404, # haproxy
        9100, # node exporter
        9256, # process exporter
      ]
      sources      = ["k3s"]
      destinations = ["jump"]
    }
  }
  "allow-k3s-to-do-telemetry" = {
    description = "Allow home network to access jump telemtry"
    rule = {
      action   = "accept"
      protocol = "tcp"
      ports = [
        9100, # node exporter
        9256, # process exporter
      ]
      sources              = ["k3s"]
      destination_resource = "do-lon"
    }
  }
}
