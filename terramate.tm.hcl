terramate {
  config {
    disable_safeguards = ["git-uncommitted", "git-untracked"]
    experiments = [
      "outputs-sharing"
    ]
  }
}

sharing_backend "default" {
  type     = terraform
  filename = "sharing_generated.tf"
  command  = ["tofu", "output", "-json"]
}
