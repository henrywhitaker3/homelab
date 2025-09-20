peers = {
  jump = {
    mesh_ip          = "10.8.0.1"
    peer_ip          = "vpn.plexmox.com"
    public_peer      = true
    post_up          = ["iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE"]
    pre_down         = ["iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE"]
    sops_config_file = "../../ansible/inventory/host_vars/jump-k8s.lab/wireguard.sops.yaml"
    peers = {
      vpn = {
        allowed_ips = ["10.0.0.0/24"]
      }
    }
  }
  macbook = {
    mesh_ip = "10.8.0.2"
    dns     = ["10.0.0.2", "10.0.0.3"]
    peers = {
      jump = {
        endpoint    = true
        allowed_ips = ["10.0.0.0/24"]
      }
    }
  }
  phone = {
    mesh_ip = "10.8.0.3"
    dns     = ["10.0.0.2", "10.0.0.3"]
    peers = {
      jump = {
        endpoint    = true
        allowed_ips = ["10.0.0.0/24"]
      }
    }
  }
  steamdeck = {
    mesh_ip = "10.8.0.4"
    dns     = ["10.0.0.2", "10.0.0.3"]
    peers = {
      jump = {
        endpoint    = true
        allowed_ips = ["10.0.0.0/24"]
      }
    }
  }
  vpn = {
    mesh_ip = "10.8.0.100"
    peers = {
      jump = {
        endpoint             = true
        persistent_keepalive = 15
        allowed_ips          = ["10.8.0.0/24"]
      }
    }
    post_up          = ["iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE"]
    pre_down         = ["iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE"]
    sops_config_file = "../../ansible/inventory/group_vars/vpn/wireguard.sops.yaml"
  }
}
