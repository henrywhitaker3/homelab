module "k8s-control-1" {
  source = "./vm"

  name   = "k8s-control-1"
  image  = local.ubuntu_22_04_300G
  ip     = 20
  cores  = 3
  memory = 12288
  node   = 1
}

module "k8s-control-2" {
  source = "./vm"

  name   = "k8s-control-2"
  image  = local.ubuntu_22_04_300G
  ip     = 21
  cores  = 3
  memory = 12288
  node   = 2
}

module "k8s-worker-1" {
  source = "./vm"

  name   = "k8s-worker-1"
  image  = local.ubuntu_22_04_300G
  ip     = 23
  cores  = 3
  memory = 12288
  node   = 1
}

module "k8s-worker-2" {
  source = "./vm"

  name   = "k8s-worker-2"
  image  = local.ubuntu_22_04_300G
  ip     = 22
  cores  = 3
  memory = 12288
  node   = 2
}
