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

variable "adguard_user" {
  type = string
}
variable "adguard_password" {
  type = string
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "grafana_oncall_url" {
  type    = string
  default = "https://oncall-prod-eu-west-0.grafana.net/oncall"
}

variable "grafana_oncall_token" {
  type      = string
  sensitive = true
}

variable "grafana_sm_url" {
  type    = string
  default = "https://synthetic-monitoring-api-eu-west-2.grafana.net"
}

variable "grafana_sm_access_token" {
  type      = string
  sensitive = true
}

variable "cronitor_api_key" {
  type      = string
  sensitive = true
}
