module "k8s-admin" {
  source = "./vm"

  name = "k8s-admin"
  image = var.ubuntu_8G
  ip = 20
  node = 1
}

module "k8s-1" {
  source = "./vm"

  name = "k8s-1"
  image = var.ubuntu_100G
  ip = 21
  cores = 2
  memory = 4096
  node = 1
}

module "k8s-2" {
  source = "./vm"

  name = "k8s-2"
  image = var.ubuntu_100G
  ip = 22
  cores = 2
  memory = 4096
  node = 2
}

module "k8s-3" {
  source = "./vm"

  name = "k8s-3"
  image = var.ubuntu_100G
  ip = 23
  cores = 2
  memory = 4096
  node = 1
}

module "k8s-4" {
  source = "./vm"

  name = "k8s-4"
  image = var.ubuntu_100G
  ip = 24
  cores = 2
  memory = 4096
  node = 2
}
