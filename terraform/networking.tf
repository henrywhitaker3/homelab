module "pihole" {
  source = "./vm"

  name = "pihole"
  image = var.ubuntu_8G
  ip = 2
  memory = 2048
  nameserver = "1.1.1.1 8.8.8.8"
}

module "haproxy" {
  source = "./vm"

  name = "haproxy"
  image = var.ubuntu_8G
  ip = 4
  memory = 512
  instances = 2
}
