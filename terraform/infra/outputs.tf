output "lb_info" {
  value = module.lb.info
}
output "k3s_control_info" {
  value = module.k3s-control.info
}

output "k3s_dedi_info" {
  value = [
    {
      name = "k3s-dedi-1"
      ip   = "10.0.0.24"
    }
  ]
}
output "adguard_info" {
  value = module.adguard.info
}

output "digitalocean_vms" {
  value = {
    netbird = {
      ip = digitalocean_droplet.netbird.ipv4_address
    }
    jump = {
      ip = digitalocean_droplet.jump_k8s.ipv4_address
    }
  }
}
