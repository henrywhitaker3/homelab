terraform {
  required_providers {
    adguard = {
      source  = "gmichels/adguard"
      version = "1.6.2"
    }
  }
}

provider "adguard" {
  host     = var.adguard_host
  username = var.adguard_user
  password = var.adguard_password
  scheme   = "http"
  timeout  = 5
}
