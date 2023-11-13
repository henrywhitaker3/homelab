module "k3s-control-1" {
  source = "./vm"

  name   = "k3s-control-1"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.23"
  cores  = 3
  memory = 12288
  node   = 1
  disk_size = "200G"
}

module "k3s-control-2" {
  source = "./vm"

  name   = "k3s-control-2"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.22"
  cores  = 3
  memory = 12288
  node   = 2
  disk_size = "200G"
}

module "k3s-worker-1" {
  source = "./vm"

  name   = "k3s-worker-1"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.20"
  cores  = 2
  memory = 8192
  node   = 1
  disk_size = "200G"
}

module "k3s-worker-2" {
  source = "./vm"

  name   = "k3s-worker-2"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.21"
  cores  = 2
  memory = 8192
  node   = 2
  disk_size = "200G"
}
