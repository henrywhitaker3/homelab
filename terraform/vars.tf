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

variable "proxmox_node_1" {
  type    = string
  default = "proxmox-01"
}

variable "proxmox_node_2" {
  type    = string
  default = "proxmox-02"
}

variable "ubuntu_8G_node_1" {
  type    = string
  default = "ubuntu-cloud-8G-node-1"
}

variable "ubuntu_25G_node_1" {
  type    = string
  default = "ubuntu-cloud-25G-node-1"
}

variable "ubuntu_100G_node_1" {
  type    = string
  default = "ubuntu-cloud-100G-node-1"
}

variable "alma_10G_node_1" {
  type    = string
  default = "alma-cloud-10G-node-1"
}

variable "ubuntu_8G_node_2" {
  type    = string
  default = "ubuntu-cloud-8G-node-2"
}

variable "ubuntu_25G_node_2" {
  type    = string
  default = "ubuntu-cloud-25G-node-2"
}

variable "ubuntu_100G_node_2" {
  type    = string
  default = "ubuntu-cloud-100G-node-2"
}

variable "alma_10G_node_2" {
  type    = string
  default = "alma-cloud-10G-node-2"
}
