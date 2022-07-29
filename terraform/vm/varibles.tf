variable "instances" {
  type = number
  default = 1
}

variable "name" {
  type = string
}

variable "node" {
  type = string
  default = "proxmox-01"
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

variable "ip" {
  type = number
  description = "The last bit of the ip (if > 1 instances, then this incremented for each further instance)"
}

variable "nameserver" {
  type = string
  default = ""
}
