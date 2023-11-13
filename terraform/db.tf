module "mariadb-1" {
  source = "./vm"

  name   = "mariadb-1"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.15"
  cores  = 2
  memory = 2048
  node   = 1
  disk_size = "25G"

  tags = [ "database", "ubuntu" ]
}

module "mariadb-2" {
  source = "./vm"

  name   = "mariadb-2"
  image  = local.ubuntu_22_04
  ip     = "10.0.0.16"
  cores  = 2
  memory = 2048
  node   = 2
  disk_size = "25G"

  tags = [ "database", "ubuntu" ]
}
