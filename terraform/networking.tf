module "pihole" {
  source = "./vm"

  name       = "pihole"
  image      = var.ubuntu_8G
  ip         = 2
  memory     = 2048
  nameserver = "1.1.1.1 8.8.8.8"
  node       = 1
}

module "haproxy-1" {
  source = "./vm"

  name   = "haproxy-1"
  image  = var.ubuntu_8G
  ip     = 4
  memory = 512
  node   = 1
}

module "haproxy-2" {
  source = "./vm"

  name   = "haproxy-2"
  image  = var.ubuntu_8G
  ip     = 5
  memory = 512
  node   = 2
}

module "vpn-1" {
  source = "./vm"

  name   = "vpn-1"
  image  = var.ubuntu_8G
  ip     = 11
  memory = 256
  node   = 1
}

module "vpn-2" {
  source = "./vm"

  name   = "vpn-2"
  image  = var.ubuntu_8G
  ip     = 12
  memory = 256
  node   = 2
}
