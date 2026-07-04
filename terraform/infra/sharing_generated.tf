// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

output "vms" {
  value = {
    adguard     = module.adguard.this
    lb          = module.lb.this
    k3s_control = module.k3s-control.this
    dev         = module.dev.this
    k3s_dedi = [{
      name = "k3s-dedi-1"
      ip   = "10.0.0.24"
    }]
  }
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
