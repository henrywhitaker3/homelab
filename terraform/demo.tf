module "demo" {
  source = "./vm"

  name   = "demo"
  image  = local.ubuntu_22_04_8G
  ip     = "10.0.0.99"
  cores  = 1
  memory = 512
  node   = 2
  disk_size = "12G"
}
