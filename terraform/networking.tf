module "pihole" {
  source = "./vm"

  name = "pihole"
  image = var.ubuntu_8G_node_1
  ip = 2
  memory = 2048
  nameserver = "1.1.1.1 8.8.8.8"
  node = var.proxmox_node_1
}

module "haproxy-1" {
  source = "./vm"

  name = "haproxy-1"
  image = var.ubuntu_8G_node_1
  ip = 4
  memory = 512
  node = var.proxmox_node_1
}

module "haproxy-2" {
  source = "./vm"

  name = "haproxy-2"
  image = var.ubuntu_8G_node_2
  ip = 5
  memory = 512
  node = var.proxmox_node_2
}
