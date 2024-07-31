terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "2.4.2"
    }

    adguard = {
      source  = "gmichels/adguard"
      version = "1.3.0"
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
