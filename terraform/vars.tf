variable "proxmox_host" {
  type    = string
  default = "10.0.0.150"
}

variable "proxmox_user" {
  type    = string
  default = "terraform"
}

variable "proxmox_token_id" {
  type      = string
  default   = "terraform"
  sensitive = true
}

variable "proxmox_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "proxmox_default_node" {
  type    = string
  default = "proxmox-01"
}

variable "ubuntu_8G" {
  type    = string
  default = "ubuntu-cloud-8G"
}

variable "ubuntu_25G" {
  type    = string
  default = "ubuntu-cloud-25G"
}

variable "ubuntu_100G" {
  type    = string
  default = "ubuntu-cloud-100G"
}

variable "alma_10G" {
  type    = string
  default = "alma-cloud-10G"
}
