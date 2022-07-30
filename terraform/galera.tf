module "galera" {
  source = "./vm"

  instances = 3

  name = "galera"
  image = var.ubuntu_8G
  ip = 5
}
