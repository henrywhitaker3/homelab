// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

output "vms" {
  value = {
    adguard = module.adguard.this
    lb      = module.lb.this
    dev     = module.dev.this
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
