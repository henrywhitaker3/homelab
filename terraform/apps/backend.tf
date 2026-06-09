// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/45412263/terraform/state/apps"
    lock_address   = "https://gitlab.com/api/v4/projects/45412263/terraform/state/apps/lock"
    lock_method    = "POST"
    unlock_address = "https://gitlab.com/api/v4/projects/45412263/terraform/state/apps/lock"
    unlock_method  = "DELETE"
    username       = "henrywhitaker3"
  }
}
