healthchecks_channels = {
  discord = {
    kind = "discord"
  }
  webhook = {
    kind = "webhook"
  }
}

healthchecks_checks = {
  speedtest = {
    name     = "Speedtest"
    grace    = 300
    timeout  = 14400
    channels = ["discord", "webhook"]
    tags     = ["warning"]
  }
  jump_k8s_lan = {
    name     = "K8s Jump server lan access"
    desc     = "Checks the k8s jump server has access to home lan"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["critical", "vpn"]
  }
  alertmanager = {
    name     = "Alertmanager"
    grace    = 120
    timeout  = 60
    channels = ["discord", "webhook"]
    tags     = ["critical"]
  }
}
