module "k8s-control-1" {
  source = "./vm"

  name   = "k8s-control-1"
  image  = local.ubuntu_22_04_100G
  ip     = 20
  cores  = 2
  memory = 8192
  node   = 1
}

module "k8s-control-2" {
  source = "./vm"

  name   = "k8s-control-2"
  image  = local.ubuntu_22_04_100G
  ip     = 21
  cores  = 2
  memory = 8192
  node   = 2
}

module "k8s-control-3" {
  source = "./vm"

  name   = "k8s-control-3"
  image  = local.ubuntu_22_04_100G
  ip     = 22
  cores  = 2
  memory = 8192
  node   = 2
}

module "k8s-worker-1" {
  source = "./vm"

  name   = "k8s-worker-1"
  image  = local.ubuntu_22_04_100G
  ip     = 23
  cores  = 2
  memory = 8192
  node   = 1
}

module "k8s-worker-2" {
  source = "./vm"

  name   = "k8s-worker-2"
  image  = local.ubuntu_22_04_100G
  ip     = 24
  cores  = 2
  memory = 8192
  node   = 1
}

module "k8s-worker-3" {
  source = "./vm"

  name   = "k8s-worker-3"
  image  = local.ubuntu_22_04_100G
  ip     = 28
  cores  = 2
  memory = 8192
  node   = 2
}
