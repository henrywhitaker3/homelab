terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc05"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}
