module "adguard" {
  source    = "./vm"
  instances = 2

  name       = "adguard"
  image      = local.ubuntu_24_04
  ips        = ["10.0.0.2", "10.0.0.3"]
  memory     = 1024
  nameserver = "1.1.1.1 8.8.8.8"
  disk_size  = "8G"
  nodes      = [3, 2]

  tags = ["dns", "networking", "ubuntu"]
}

module "lb" {
  source    = "./vm"
  instances = 2

  name      = "lb"
  image     = local.ubuntu_24_04
  ips       = ["10.0.0.4", "10.0.0.5"]
  memory    = 1024
  disk_size = "8G"
  nodes     = [1, 3]

  tags = ["lb", "networking", "ubuntu"]
}

module "vpn" {
  source    = "./vm"
  instances = 2

  name      = "vpn"
  image     = local.ubuntu_24_04
  ips       = ["10.0.0.11", "10.0.0.12"]
  memory    = 512
  disk_size = "8G"
  nodes     = [1, 2]

  tags = ["networking", "ubuntu", "vpn"]
}

