generate_hcl "backend.tf" {
  content {
    terraform {
      backend "http" {
        address        = "https://gitlab.com/api/v4/projects/45412263/terraform/state/${terramate.stack.path.basename}"
        lock_address   = "https://gitlab.com/api/v4/projects/45412263/terraform/state/${terramate.stack.path.basename}/lock"
        lock_method    = "POST"
        unlock_address = "https://gitlab.com/api/v4/projects/45412263/terraform/state/${terramate.stack.path.basename}/lock"
        unlock_method  = "DELETE"
        username       = "henrywhitaker3"
      }
    }
  }
}
