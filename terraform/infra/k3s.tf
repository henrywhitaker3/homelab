module "k3s-control" {
  source = "./vm"
  instances = 2

  name       = "k3s-control"
  image      = local.ubuntu_22_04
  ips         = ["10.0.0.23", "10.0.0.22"]
  nameserver = "1.1.1.1 8.8.8.8"
  cores      = 3
  memory     = 12288
  disk_size  = "300G"
  nodes      = [1, 2]

  tags = ["control", "k3s", "ubuntu"]
}

module "k3s-worker" {
  source    = "./vm"
  instances = 2

  name       = "k3s-worker"
  image      = local.ubuntu_22_04
  ips         = ["10.0.0.20", "10.0.0.21"]
  nameserver = "1.1.1.1 8.8.8.8"
  cores      = 2
  memory     = 8192
  disk_size  = "300G"
  nodes      = [1, 2]

  tags = ["agent", "k3s", "ubuntu"]
}
