stack {
  name        = "infra"
  description = "infra"
  tags        = ["talos"]
  id          = "26657b10-825a-416f-b0f4-16d821c773e8"
}

output "vms" {
  backend = "default"
  value = {
    adguard = module.adguard.this
    dev     = module.dev.this
  }
}

output "digitalocean_vms" {
  backend = "default"
  value = {
    netbird = {
      ip = digitalocean_droplet.netbird.ipv4_address
    }
    jump = {
      ip = digitalocean_droplet.jump_k8s.ipv4_address
    }
  }
}
