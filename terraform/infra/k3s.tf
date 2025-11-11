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
