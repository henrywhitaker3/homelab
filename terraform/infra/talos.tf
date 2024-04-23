module "mango-control-1" {
  source = "./talos"

  name        = "mango-control-1"
  node        = 1
  cores       = 2
  memory      = 2048
  disk_size   = 200
  mac_address = "18:2f:a3:3e:dc:7a"
}

module "mango-control-2" {
  source = "./talos"

  name        = "mango-control-2"
  node        = 2
  cores       = 2
  memory      = 2048
  disk_size   = 200
  mac_address = "18:88:df:e5:c2:99"
}

module "mango-control-3" {
  source = "./talos"

  name        = "mango-control-3"
  node        = 3
  cores       = 2
  memory      = 2048
  disk_size   = 200
  mac_address = "18:e7:3e:fa:e1:f9"
}
