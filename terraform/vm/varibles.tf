variable "instances" {
  type = number
  default = 1
}

variable "name" {
  type = string
}

variable "node" {
  type = number
}

variable "image" {
  type = string
}

variable "cores" {
  type = number
  default = 1
}

variable "memory" {
  type = number
  default = 512
}

variable "subnet" {
  type = string
  default = "10.0.0.0/24"
}

variable "ip" {
  type = string
  description = "The ip (if > 1 instances, then this incremented for each further instance)"
}

variable "nameserver" {
  type = string
  default = ""
}

variable "gateway" {
  type = string
  default = "10.0.0.1"
}

variable "disk_size" {
  type = string
  default = "8192M"
}

variable "disk_storage" {
  type = string
  default = "local-lvm"
}

variable "disk_type" {
  type = string
  default = "scsi"
}
