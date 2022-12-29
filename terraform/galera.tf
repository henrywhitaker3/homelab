module "mariadb" {
  source = "./vm"

  name   = "mariadb"
  image  = var.ubuntu_100G
  ip     = 10
  node   = 2
  cores  = 2
  memory = 4096
}

# module "galera-1" {
#   source = "./vm"

#   name = "galera-1"
#   image = var.ubuntu_100G
#   ip = 16
#   node = 1
#   memory = 1024
# }

# module "galera-2" {
#   source = "./vm"

#   name = "galera-2"
#   image = var.ubuntu_100G
#   ip = 17
#   node = 2
#   memory = 1024
# }

# module "galera-3" {
#   source = "./vm"

#   name = "galera-3"
#   image = var.ubuntu_100G
#   ip = 18
#   node = 2
#   memory = 1024
# }
