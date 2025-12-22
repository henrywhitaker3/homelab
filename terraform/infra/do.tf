resource "digitalocean_ssh_key" "laptop" {
  name       = "Laptop"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpK3VfLOVkG5nffVI+mEagvSXBe2cl8k4KTKlhDxR6a"
}

resource "digitalocean_vpc" "jump_vpc" {
  name     = "jump-net"
  region   = "lon1"
  ip_range = "10.100.0.0/24"
}

resource "digitalocean_droplet" "jump_k8s" {
  name     = "jump-k8s"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-24-04-x64"
  region   = "lon1"
  vpc_uuid = digitalocean_vpc.jump_vpc.id
  ssh_keys = [digitalocean_ssh_key.laptop.fingerprint]
}

resource "digitalocean_droplet" "netbird" {
  name     = "netbird"
  size     = "s-2vcpu-2gb"
  image    = "ubuntu-24-04-x64"
  region   = "lon1"
  vpc_uuid = digitalocean_vpc.jump_vpc.id
  ssh_keys = [digitalocean_ssh_key.laptop.fingerprint]
}

data "cloudflare_ip_ranges" "this" {}

resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = [
    digitalocean_droplet.jump_k8s.id
  ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "51820"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "123"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol                = "tcp"
    destination_droplet_ids = [digitalocean_droplet.netbird.id]
    port_range              = "1-65535"
  }

  outbound_rule {
    protocol                = "udp"
    destination_droplet_ids = [digitalocean_droplet.netbird.id]
    port_range              = "1-65535"
  }

}

resource "digitalocean_firewall" "netbird" {
  name = "netbird"

  droplet_ids = [
    digitalocean_droplet.netbird.id
  ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "33080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "3478"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol           = "tcp"
    source_droplet_ids = [digitalocean_droplet.jump_k8s.id]
    port_range         = "1-65535"
  }

  inbound_rule {
    protocol           = "udp"
    source_droplet_ids = [digitalocean_droplet.jump_k8s.id]
    port_range         = "1-65535"
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "123"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
