module "k8s-admin" {
  source = "./vm"

  name = "k8s-admin"
  image = var.ubuntu_8G_node_1
  ip = 20
  node = var.proxmox_node_1
}

module "k8s-1" {
  source = "./vm"

  name = "k8s-1"
  image = var.ubuntu_100G_node_1
  ip = 21
  cores = 2
  memory = 4096
  node = var.proxmox_node_1
}

module "k8s-2" {
  source = "./vm"

  name = "k8s-2"
  image = var.ubuntu_100G_node_2
  ip = 22
  cores = 2
  memory = 4096
  node = var.proxmox_node_2
}

module "k8s-3" {
  source = "./vm"

  name = "k8s-3"
  image = var.ubuntu_100G_node_1
  ip = 23
  cores = 2
  memory = 4096
  node = var.proxmox_node_1
}

module "k8s-4" {
  source = "./vm"

  name = "k8s-4"
  image = var.ubuntu_100G_node_2
  ip = 24
  cores = 2
  memory = 4096
  node = var.proxmox_node_2
}
