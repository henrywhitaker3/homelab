module "actions" {
  source    = "./vm"
  instances = 1

  name       = "actions"
  image      = local.ubuntu_24_04
  ips        = ["10.0.0.17"]
  memory     = 2048
  nameserver = "1.1.1.1 8.8.8.8"
  disk_size  = "24G"
  nodes      = [3]

  tags = ["github", "ubuntu"]
}
