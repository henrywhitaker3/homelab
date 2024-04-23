variable "name" {
  type        = string
  description = "The name of the vm"
}

variable "iso" {
  type        = string
  description = "The iso the create the vm from"
  default     = "talos.iso"
}

variable "iso_storage" {
  type        = string
  description = "The storage the iso is stored in"
  default     = "local"
}

variable "storage" {
  type        = string
  description = "The storage to create the vm disk on"
  default     = "local-lvm"
}

variable "cores" {
  type        = number
  description = "The number of cores to give the vm"
}

variable "memory" {
  type        = number
  description = "The amount of memory to allocate the vm"
}

variable "node" {
  type        = number
  description = "The node to schedule the vm on"
}

variable "disk_size" {
  type        = number
  description = "The size of the vm disk"
}

variable "tags" {
  type        = list(string)
  description = "The tags to give the vm"
  default     = ["talos"]
}

variable "mac_address" {
  type        = string
  description = "The MAC address of the vm (needed for dhcp so we can have 'static' ips)"
}

variable "network_bridge" {
  type        = string
  description = "The network bridge to use"
  default     = "vmbr0"
}
