module "adguard" {
  source    = "./vm"
  instances = 2

  name       = "adguard"
  image      = local.ubuntu_22_04
  ip         = "10.0.0.2"
  memory     = 512
  nameserver = "1.1.1.1 8.8.8.8"
  disk_size  = "8G"
  nodes      = [1, 2]

  tags = ["dns", "networking", "ubuntu"]
}

module "lb" {
  source    = "./vm"
  instances = 2

  name      = "lb"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.4"
  memory    = 512
  disk_size = "8G"
  nodes     = [1, 2]

  tags = ["lb", "networking", "ubuntu"]
}

module "vpn" {
  source    = "./vm"
  instances = 2

  name      = "vpn"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.11"
  memory    = 512
  disk_size = "8G"
  nodes     = [1, 2]

  tags = ["networking", "ubuntu", "vpn"]
}

