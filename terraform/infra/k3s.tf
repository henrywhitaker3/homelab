module "k3s-control" {
  source    = "./vm"
  instances = 3

  name       = "k3s-control"
  image      = local.ubuntu_22_04
  ips        = ["10.0.0.23", "10.0.0.22", "10.0.0.19"]
  nameserver = "1.1.1.1 8.8.8.8"
  cores      = 6
  memory     = 16384
  disk_size  = "500G"
  nodes      = [1, 2, 3]

  tags = ["control", "k3s", "ubuntu"]
}

module "k3s-vpn" {
  source = "./vm"

  instances  = 2
  name       = "k3s-vpn"
  image      = local.ubuntu_22_04
  ips        = ["10.0.0.20", "10.0.0.21"]
  nameserver = "1.1.1.1 8.8.8.8"
  cores      = 1
  memory     = 2048
  disk_size  = "16G"
  nodes      = [1, 2]
  serial     = true

  tags = ["worker", "vpn", "k3s", "ubuntu"]
}
