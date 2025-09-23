terraform {
  required_version = ">= 1.10.6"
  required_providers {
    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.4.0"
    }
    sops = {
      source  = "nobbs/sops"
      version = "0.3.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }

  backend "http" {
  }
}
