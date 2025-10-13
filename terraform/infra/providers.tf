terraform {
  required_version = "~>1.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.68.0"
    }

    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "2.3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.52.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }

  backend "http" {
  }
}

provider "proxmox" {
  pm_api_url          = "https://${local.proxmox_host}:8006/api2/json"
  pm_api_token_id     = "${var.proxmox_user}@pam!${var.proxmox_token_id}"
  pm_api_token_secret = var.proxmox_token
  pm_tls_insecure     = true
  pm_parallel         = 1
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
