resource "digitalocean_vpc" "jump_vpc" {
  name     = "jump-net"
  region   = "lon1"
  ip_range = "10.100.0.0/24"
}
