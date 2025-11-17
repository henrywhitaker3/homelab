terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.0"
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
