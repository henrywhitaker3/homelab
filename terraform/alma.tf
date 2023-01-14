module "alma" {
  source = "./vm"

  name  = "alma"
  image = local.alma_9_10G
  ip    = 15
  node  = 2
}
