module "k8s-admin" {
  source = "./vm"

  name = "k8s-admin"
  image = var.ubuntu_8G
  ip = 20
}

module "k8s-nodes" {
  source = "./vm"

  name = "k8s"
  image = var.ubuntu_100G
  ip = 21
  instances = 2
  cores = 2
  memory = 4096
}
