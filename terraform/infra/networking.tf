module "adguard-1" {
  source = "./vm"

  name       = "adguard-1"
  image      = local.ubuntu_22_04
  ip         = "10.0.0.2"
  memory     = 512
  nameserver = "1.1.1.1 8.8.8.8"
  node       = 1
  disk_size  = "8G"

  tags = ["dns", "networking", "ubuntu"]
}

module "adguard-2" {
  source = "./vm"

  name       = "adguard-2"
  image      = local.ubuntu_22_04
  ip         = "10.0.0.3"
  memory     = 512
  nameserver = "1.1.1.1 8.8.8.8"
  node       = 2
  disk_size  = "8G"

  tags = ["dns", "networking", "ubuntu"]
}

module "lb-1" {
  source = "./vm"

  name      = "lb-1"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.4"
  memory    = 512
  node      = 1
  disk_size = "8G"

  tags = ["lb", "networking", "ubuntu"]
}

module "lb-2" {
  source = "./vm"

  name      = "lb-2"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.5"
  memory    = 512
  node      = 2
  disk_size = "8G"

  tags = ["lb", "networking", "ubuntu"]
}

module "vpn-1" {
  source = "./vm"

  name      = "vpn-1"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.11"
  memory    = 512
  node      = 1
  disk_size = "8G"

  tags = ["networking", "ubuntu", "vpn"]
}

module "vpn-2" {
  source = "./vm"

  name      = "vpn-2"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.12"
  memory    = 512
  node      = 2
  disk_size = "8G"

  tags = ["networking", "ubuntu", "vpn"]
}
