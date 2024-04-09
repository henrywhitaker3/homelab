variable "name" {
  type        = string
  description = "The name of the user/policy"
}

variable "buckets" {
  type        = list(string)
  description = "The names of the bucket/user to create"
}

variable "permissions" {
  type        = list(string)
  description = "The permissions the user will have for the bucket"
}

variable "retention" {
  type        = number
  description = "The number of days after which objects will get expired. Set to 0 for no expiration."
  default     = 0
}

variable "acl" {
  type        = string
  description = "The ACL for the bucket"
  default     = "private"
  validation {
    condition     = contains(["public", "private", "public-read"], var.acl)
    error_message = "Invalid acl"
  }
}
