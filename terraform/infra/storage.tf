module "minio" {
  source    = "./vm"
  instances = 2

  name      = "minio"
  image     = local.ubuntu_24_04
  ips       = ["10.0.0.15", "10.0.0.16"]
  cores     = 1
  memory    = 6144
  disk_size = "100G"
  nodes     = [1, 2]

  tags = ["minio", "ubuntu"]
}
