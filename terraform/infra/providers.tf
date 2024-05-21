terraform {
  required_version = "~>1.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc2"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.38.0"
    }

    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "2.0.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.33.0"
    }
  }

  backend "http" {
  }
}

provider "proxmox" {
  pm_api_url = "https://${local.proxmox_host}:8006/api2/json"

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

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
