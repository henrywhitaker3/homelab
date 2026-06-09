variable "zone" {
  type        = string
  description = "The zone name"
}

variable "records" {
  type = map(object({
    name    = string
    value   = string
    type    = string
    proxied = optional(bool, true)
  }))
  default = {}
}

variable "geo_block" {
  type        = list(string)
  description = "Country codes to geo-block"
  default     = ["RU", "CN", "BY", "IR", "PK", "SG", "IN", "PH", "HK", "JP", "KR"]
}
