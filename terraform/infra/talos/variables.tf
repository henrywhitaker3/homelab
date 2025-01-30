variable "cluster_name" {
  type = string
}

variable "talos_version" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "talos_image_filters" {
  type = list(string)
}

variable "proxmox_nodes" {
  type    = list(string)
  default = ["proxmox-01", "proxmox-02", "proxmox-03"]
}

variable "iso_storage" {
  type    = string
  default = "local"
}

variable "nodes" {
  type = list(object({
    type        = string
    node        = number
    cpus        = number
    memory      = number
    mac_address = string
    ip          = string
    patches     = optional(list(any), [])
    disks = optional(map(object({
      size = number
    })), {})
  }))
}

variable "control_plane_ip" {
  type = string
}

variable "cluster_service_cidr" {
  type    = string
  default = "10.96.0.0/16"
}

variable "cluster_pod_cidr" {
  type    = string
  default = "10.69.0.0/16"
}

variable "cluster_cni" {
  type    = string
  default = "none"
}

variable "nameservers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "patches" {
  type    = list(any)
  default = []
}

variable "routes" {
  type = list(object({
    network = string
    gateway = string
  }))
}

variable "kubeconfig_file" {
  type        = string
  description = "The path to store the kubeconfig in"
}

variable "helmfile" {
  type    = string
  default = null
}
