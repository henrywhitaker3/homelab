gitlab_projects = {
  homelab = {
    name = "henrywhitaker3/homelab"
  }
}

gitlab_users = {
  henry = {
    name = "henrywhitaker3"
  }
}

gitlab_project_access_tokens = {
  renoavte = {
    name         = "Renovate"
    project      = "homelab"
    access_level = "Developer"
    scopes       = ["api", "read_repository", "write_repository"]
  }
}

gitlab_personal_access_tokens = {
  terraform = {
    name   = "Terraform"
    user   = "henry"
    scopes = ["api"]
  }
}

gitlab_project_variables = {
  renovate = {
    name    = "RENOVATE_TOKEN"
    value   = "gitlab.pat.renovate"
    project = "homelab"
  }
  terraform = {
    name    = "TERRAFORM_ACCESS_TOKEN"
    value   = "gitlab.pat.terraform"
    project = "homelab"
  }
}
