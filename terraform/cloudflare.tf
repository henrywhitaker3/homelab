data "cloudflare_zone" "plexmox_com" {
  name = "plexmox.com"
}

resource "cloudflare_record" "root" {
  zone_id = data.cloudflare_zone.plexmox_com.zone_id
  name    = "plexmox.com"
  value   = digitalocean_droplet.jump_k8s.ipv4_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "plex" {
  zone_id = data.cloudflare_zone.plexmox_com.zone_id
  name    = "plex"
  value   = digitalocean_droplet.jump_k8s.ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "vpn" {
  zone_id = data.cloudflare_zone.plexmox_com.zone_id
  name    = "vpn"
  value   = digitalocean_droplet.jump_k8s.ipv4_address
  type    = "A"
}

resource "cloudflare_record" "wildcard" {
  zone_id = data.cloudflare_zone.plexmox_com.zone_id
  name    = "*"
  value   = "plexmox.com"
  type    = "CNAME"
  proxied = true
}
