module "galera-1" {
  source = "./vm"

  name = "galera-1"
  image = var.ubuntu_8G_node_1
  ip = 16
  node = var.proxmox_node_1
  memory = 1024
}

module "galera-2" {
  source = "./vm"

  name = "galera-2"
  image = var.ubuntu_8G_node_2
  ip = 17
  node = var.proxmox_node_2
  memory = 1024
}

module "galera-3" {
  source = "./vm"

  name = "galera-3"
  image = var.ubuntu_8G_node_2
  ip = 18
  node = var.proxmox_node_2
  memory = 1024
}
