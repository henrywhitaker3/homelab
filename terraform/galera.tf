module "galera" {
  source = "./vm"

  name = "galera"
  image = var.ubuntu_8G
  ip = 16
  instances = 3
}
