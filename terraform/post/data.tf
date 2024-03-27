data "terraform_remote_state" "infra" {
  backend = "http"
  config = {
    address  = var.infra_state_url
    username = "henrywhitaker3"
    password = var.infra_state_token
  }
}
