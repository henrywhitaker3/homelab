module "henrywhitaker-com" {
  source = "./cloudflare"

  zone = "henrywhitaker.com"
}

module "plexmox-com" {
  source = "./cloudflare"

  zone = "plexmox.com"
  records = [
    {
      name    = "plexmox.com"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    },
    {
      name    = "plex"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = false
    },
    {
      name    = "vpn"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = false
    },
    {
      name    = "*"
      value   = "plexmox.com"
      type    = "CNAME"
      proxied = true
    },
  ]
}

module "srep-io" {
  source = "./cloudflare"

  zone = "srep.io"

  records = [
    {
      name    = "srep.io"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    },
    {
      name    = "api"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
  ]
}
