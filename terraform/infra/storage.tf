module "minio-1" {
  source = "./vm"

  name      = "minio-1"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.15"
  cores     = 1
  memory    = 2048
  node      = 1
  disk_size = "100G"

  tags = ["minio", "ubuntu"]
}

module "minio-2" {
  source = "./vm"

  name      = "minio-2"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.16"
  cores     = 1
  memory    = 2048
  node      = 2
  disk_size = "100G"

  tags = ["minio", "ubuntu"]
}
