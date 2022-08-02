module "alma" {
  source = "./vm"

  name = "alma"
  image = var.alma_10G_node_1
  ip = 15
  node = var.proxmox_node_1
}
