module "dev" {
  source = "../modules/vm"

  name      = "dev"
  image     = local.ubuntu_26_04
  ips       = ["10.0.0.15"]
  memory    = 4096
  disk_size = "64G"
  nodes     = [1]

  tags = ["dev", "ubuntu"]
}
