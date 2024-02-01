module "actions" {
  source = "./vm"

  name       = "actions"
  image      = local.ubuntu_22_04
  ip         = "10.0.0.18"
  memory     = 2048
  cores      = 2
  nameserver = "1.1.1.1 8.8.8.8"
  node       = 2
  disk_size  = "8G"

  tags = ["srep", "ubuntu"]
}
