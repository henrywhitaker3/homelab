terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "3.2.3"
    }

    adguard = {
      source  = "gmichels/adguard"
      version = "1.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.18.3"
    }
    cronitor = {
      source  = "henrywhitaker3/cronitor"
      version = "1.2.1"
    }
  }

  backend "http" {
  }
}

provider "minio" {
  minio_server   = var.minio_server
  minio_user     = var.minio_user
  minio_password = var.minio_password
  minio_ssl      = true
}

provider "adguard" {
  alias    = "adguard-1"
  host     = data.terraform_remote_state.infra.outputs.adguard_info[0].ip
  username = var.adguard_user
  password = var.adguard_password
  scheme   = "http"
  timeout  = 5
}

provider "adguard" {
  alias    = "adguard-2"
  host     = data.terraform_remote_state.infra.outputs.adguard_info[1].ip
  username = var.adguard_user
  password = var.adguard_password
  scheme   = "http"
  timeout  = 5
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "grafana" {
  oncall_url          = var.grafana_oncall_url
  oncall_access_token = var.grafana_oncall_token
  sm_url              = var.grafana_sm_url
  sm_access_token     = var.grafana_sm_access_token
}

provider "cronitor" {
  api_key = var.cronitor_api_key
}
