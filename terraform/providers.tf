terraform {
  required_version = "~>1.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.31.0"
    }

    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "1.10.1"
    }

    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.0.12"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
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

provider "pihole" {
  url       = var.pihole_url
  api_token = var.pihole_api_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
