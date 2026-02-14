variable "adguard_host" {
  type = string
}

variable "adguard_user" {
  type = string
}

variable "adguard_password" {
  type = string
}

variable "vms" {
  type = list(object({
    name = string
    ip   = string
  }))
  default = []
}

variable "internal_ingress_targets" {
  type    = list(string)
  default = []
}

variable "custom_rewrites" {
  type = list(object({
    src  = string
    dest = string
  }))
  default = []
}

variable "filter_rules" {
  type    = list(string)
  default = []
}

variable "internal_ingress_ip" {
  type    = string
  default = "10.0.0.27"
}

variable "safesearch_enabled" {
  type    = bool
  default = false
}

variable "query_log_enabled" {
  type    = bool
  default = true
}

variable "query_log_interval" {
  type    = number
  default = 30
}

variable "stats_enabled" {
  type    = bool
  default = true
}

variable "stats_interval" {
  type    = number
  default = 24
}

variable "dns_rate_limit" {
  type    = number
  default = 20
}

variable "upstream_dns" {
  type    = list(string)
  default = []
}

variable "bootstrap_dns" {
  type    = list(string)
  default = []
}

variable "filter_lists" {
  type = list(object({
    name = string
    url  = string
  }))
}

variable "dhcp_enabled" {
  type    = bool
  default = false
}

variable "dhcp_interface" {
  type    = string
  default = "eth0"
}

variable "dhcp_ipv4_settings" {
  type = object({
    gateway_ip     = string
    lease_duration = number
    range_start    = string
    range_end      = string
    subnet_mask    = string
  })
  default = {
    gateway_ip     = ""
    lease_duration = 0
    range_start    = ""
    range_end      = ""
    subnet_mask    = ""
  }
}

variable "dhcp_static_leases" {
  type = list(object({
    mac      = string
    ip       = string
    hostname = string
  }))
  default = []
}

variable "filtering_enabled" {
  type    = bool
  default = true
}
