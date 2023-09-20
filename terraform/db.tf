module "mariadb-1" {
  source = "./vm"

  name   = "mariadb-1"
  image  = local.ubuntu_22_04_25G
  ip     = 15
  cores  = 2
  memory = 2048
  node   = 1
}

module "mariadb-2" {
  source = "./vm"

  name   = "mariadb-2"
  image  = local.ubuntu_22_04_25G
  ip     = 16
  cores  = 2
  memory = 2048
  node   = 2
}
