terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }

    pihole = {
      source = "ryanwholey/pihole"
      version = "0.0.12"
    }
  }
}
