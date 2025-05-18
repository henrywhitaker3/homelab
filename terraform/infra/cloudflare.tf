module "henrywhitaker-com" {
  source = "./cloudflare"

  zone = "henrywhitaker.com"
  records = {
    root = {
      name    = "henrywhitaker.com"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
    wildcard = {
      name    = "*"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
    voodoo = {
      name    = "voodoo"
      value   = "www.voiceandsms.com"
      type    = "CNAME"
      proxied = false
    }
  }
}

module "plexmox-com" {
  source = "./cloudflare"

  zone = "plexmox.com"
  records = {
    root = {
      name    = "plexmox.com"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
    plex = {
      name    = "plex"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = false
    }
    vpn = {
      name    = "vpn"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = false
    }
    star = {
      name    = "*"
      value   = "plexmox.com"
      type    = "CNAME"
      proxied = true
    }
  }
}

module "srep-io" {
  source = "./cloudflare"

  zone = "srep.io"

  records = {
    root = {
      name    = "srep.io"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
    api = {
      name    = "api"
      value   = digitalocean_droplet.jump_k8s.ipv4_address
      type    = "A"
      proxied = true
    }
  }
}
