module "alma" {
  source = "./vm"

  name  = "alma"
  image = var.alma_10G
  ip    = 15
  node  = 2
}
