module "dev" {
  source = "../modules/vm"

  name      = "dev"
  image     = local.ubuntu_26_04
  ips       = ["10.0.0.15"]
  cores     = 4
  memory    = 4096
  disk_size = "64G"
  nodes     = [1]
  serial    = true

  tags = ["dev", "ubuntu"]
}
