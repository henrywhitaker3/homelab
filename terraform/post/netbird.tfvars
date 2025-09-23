netbird_networks = {
  "home"   = {}
  "do-lon" = {}
  "k3s-cluster" = {
    data = true
  }
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
    peers = ["phone", "mbp", "mac-mini", "tablet"]
  }
  "jump" = {
    peers = ["jump-k8s"]
  }
  "telemetry" = {
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
  "mac-mini" = {}
  "tablet"   = {}
}

netbird_resources = {
  "external-ingress" = {
    name    = "ingress-nginx-ingress-nginx-controller"
    network = "k3s-cluster"
    data    = true
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
    groups  = ["All"]
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
  "allow-k3s-to-jump-telemetry" = {
    description = "Allow home network to access jump telemetry"
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
    description = "Allow home network to access do telemetry"
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
  "allow-all-to-k3s-telemetry" = {
    description = "Allow all devices to connect to telemetry services running in k3s"
    rule = {
      action   = "accept"
      protocol = "tcp"
      ports = [
        3100,  # loki http
        9095,  # loki grpc
        6831,  # tempo jaeger
        6832,  # tempo jaeger-thrift-binary
        3200,  # tempo prom-metrics
        14268, # tempo jaeger-thrift-http
        14250, # tempo grpc-jaeger
        9411,  # tempo zipkin
        55680, # tempo otlp-legacy
        55681, # tempo otlp-http-legacy
        4317,  # tempo grpc-otlp
        4318,  # tempo otlp-http
        55678, # tempo opencensus
        8429,  # victoria-metrics
        4040,  # pyroscope
      ]
      sources      = ["All"]
      destinations = ["telemetry"]
    }
  }
}
