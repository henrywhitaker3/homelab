module "pihole" {
  source = "./vm"

  name       = "pihole"
  image      = local.ubuntu_22_04_8G
  ip         = "10.0.0.2"
  memory     = 2048
  nameserver = "1.1.1.1 8.8.8.8"
  node       = 2
  disk_size = "10444M"
}

module "haproxy-1" {
  source = "./vm"

  name   = "lb-1"
  image  = local.ubuntu_22_04_8G
  ip     = "10.0.0.4"
  memory = 512
  node   = 1
  disk_size = "10444M"
}

module "haproxy-2" {
  source = "./vm"

  name   = "lb-2"
  image  = local.ubuntu_22_04_8G
  ip     = "10.0.0.5"
  memory = 512
  node   = 2
  disk_size = "10444M"
}

module "vpn-1" {
  source = "./vm"

  name   = "vpn-1"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.11"
  memory = 512
  node   = 1
  disk_size = "8G"
}

module "vpn-2" {
  source = "./vm"

  name   = "vpn-2"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.12"
  memory = 512
  node   = 2
  disk_size = "8G"
}
