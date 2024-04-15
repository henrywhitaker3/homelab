module "minio" {
  source    = "./vm"
  instances = 2

  name      = "minio"
  image     = local.ubuntu_22_04
  ip        = "10.0.0.15"
  cores     = 1
  memory    = 2048
  disk_size = "100G"
  nodes     = [1, 2]

  tags = ["minio", "ubuntu"]
}
