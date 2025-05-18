resource "digitalocean_ssh_key" "laptop" {
  name       = "Laptop"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+Ho5rRpj4vpLNcAxKvy255db7Hr65mO8C4BNRB2yYcLTBkHG8N1mFsMbMQPqL0qCSYqS0+mRz/QN2W8JLa/pX5b2QffvisYKCNnxHzesyB78rmTh5JKO50ykZq9iJFAADD49yfYoP9v1I6RT8bLpGcdKugRsPzZqd3XskPa6uot8GZBkQ+0THcErvF8OQn1mIj03jQTFusCmIn2GzdQRnb0D8cbs1oDkiiXQMvNRtrymiNR2JA+2gXDnTKjxW87BGhFfP2UNrGVpbmTHQs4Jzm44opTixCA0gSNlDzYChlyWmrZbhgLipDWhrdpg5k2KdbZC4XX19X10voATfEUWV0vM4mk4BxOFPSEaeRInA+cM/8WZ1FEiANMmPzLRIgZh3lqyvJ7L0WUB9pm0XTtmD2bHpQ2/lk4XyVQ4iRgsE3D/3UD0d7T/I7virVXWSk4H1m4+92zCKQLduGeqH7AFEPrGYJvVYR0VkbBnMcTHfgFyIRWdyl7O+IBl+j7KAYV0="
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
}
