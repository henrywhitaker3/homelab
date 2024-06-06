terraform {
  required_providers {
    adguard = {
      source  = "gmichels/adguard"
      version = "1.3.0"
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
