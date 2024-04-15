variable "instances" {
  type    = number
  default = 1
}

variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 512
}

variable "subnet" {
  type    = string
  default = "10.0.0.0/24"
}

variable "ips" {
  type        = list(string)
  description = "The ips of the instances"
}

variable "nameserver" {
  type    = string
  default = ""
}

variable "gateway" {
  type    = string
  default = "10.0.0.1"
}

variable "disk_size" {
  type    = string
  default = "8192M"
}

variable "disk_storage" {
  type    = string
  default = "local-lvm"
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "nodes" {
  type        = list(number)
  description = "Provide a list of nodes that the vms will be scheduled onto"
}
