variable "do_token" {
  type      = string
  sensitive = true
}

variable "healthchecksio_api_key" {
  type      = string
  sensitive = true
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

variable "pihole_url" {
  type = string
  default = ""
}

variable "pihole_api_token" {
  type = string
  default = ""
  sensitive = true
}
