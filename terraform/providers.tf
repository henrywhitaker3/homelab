terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }

    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "1.9.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.proxmox_host}:8006/api2/json"

  pm_api_token_id = "${var.proxmox_user}@pam!${var.proxmox_token_id}"

  pm_api_token_secret = var.proxmox_token

  pm_tls_insecure = true
}

provider "digitalocean" {
  token = var.do_token
}

provider "healthchecksio" {
  api_key = var.healthchecksio_api_key
}
