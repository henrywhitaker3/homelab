module "adguard" {
  source    = "../modules/vm"
  instances = 2

  name       = "adguard"
  image      = local.ubuntu_24_04
  ips        = ["10.0.0.2", "10.0.0.3"]
  memory     = 1024
  nameserver = "1.1.1.1 8.8.8.8"
  disk_size  = "8G"
  nodes      = [3, 2]

  tags = ["dns", "networking", "ubuntu"]
}
