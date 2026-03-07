terraform {
  required_version = ">= 1.10.6"
  required_providers {
    pocketid = {
      source  = "trozz/pocketid"
      version = "0.1.7"
    }
  }

  backend "http" {
  }
}

variable "pocketid_api_token" {
  type      = string
  sensitive = true
}

provider "pocketid" {
  base_url  = "https://pocket.plexmox.com"
  api_token = var.pocketid_api_token
}
