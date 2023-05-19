module "nomad-1" {
  source = "./vm"

  name   = "nomad-1"
  image  = local.ubuntu_22_04_25G
  ip     = 31
  memory = 2048
  cores  = 1
  node   = 1
}
