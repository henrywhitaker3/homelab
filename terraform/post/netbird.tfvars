netbird_networks = {
  "home"   = {}
  "do-lon" = {}
}

netbird_setup_keys = {
  "jump" = {
    auto_groups = ["jump"]
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
  "devices" = {
    peers = ["phone", "mbp"]
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
  "phone"    = {}
  "jump-k8s" = {}
  "mbp"      = {}
}

netbird_resources = {
  "home" = {
    network = "home"
    groups  = ["homelab"]
    address = "10.0.0.0/24"
  }
  "adguard-1" = {
    network = "home"
    groups  = ["homelab"]
    address = "10.0.0.2/32"
  }
  "adguard-2" = {
    network = "home"
    groups  = ["homelab"]
    address = "10.0.0.3/32"
  }
  "external-ingress" = {
    network = "home"
    groups  = ["homelab"]
    address = "10.0.0.25/32"
  }
  "loki" = {
    network = "home"
    groups  = ["homelab"]
    address = "10.0.0.27/32"
  }
  "do-lon" = {
    network = "do-lon"
    groups  = ["jump"]
    address = "10.100.0.0/24"
  }
}

netbird_nameservers = {
  "jump-adguard" = {
    description            = "Use adguard for plexmox and lab domains"
    domains                = ["plexmox.com"]
    search_domains_enabled = true
    groups                 = ["jump"]
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
  "devices-to-home" = {
    description = "Allow devices to access home network"
    rule = {
      description          = "Allow all from devices -> home"
      action               = "accept"
      protocol             = "all"
      sources              = ["devices"]
      destination_resource = "home"
    }
  }
  "devices-to-do-lon" = {
    description = "Allow devices to access all groups"
    rule = {
      description          = "Allow all from devices -> all"
      action               = "accept"
      protocol             = "all"
      sources              = ["devices"]
      destination_resource = "do-lon"
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
  "allow-jump-to-loki" = {
    description = "Allow access to loki"
    rule = {
      action               = "accept"
      protocol             = "tcp"
      ports                = [80, 443]
      sources              = ["jump"]
      destination_resource = "loki"
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
