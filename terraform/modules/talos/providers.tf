terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc10"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.14.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.1"
    }
  }
}
