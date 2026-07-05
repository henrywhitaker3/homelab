terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc08"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.0"
    }
  }
}
