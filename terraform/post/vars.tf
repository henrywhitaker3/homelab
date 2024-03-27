variable "minio_user" {
  type = string
}

variable "minio_password" {
  type = string
}

variable "minio_server" {
  type = string
}

variable "infra_state_url" {
  type        = string
  description = "The URL for the infra remote state"
}

variable "infra_state_token" {
  type        = string
  description = "The token to access the infra remote state"
}

variable "pihole_url" {
  type = string
}
variable "pihole_api_token" {
  type = string
}
