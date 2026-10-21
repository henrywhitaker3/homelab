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
  lb_1 = {
    name     = "LB 1"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["warning", "lb"]
  }
  lb_2 = {
    name     = "LB 2"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["warning", "lb"]
  }
  alertmanager = {
    name     = "Alertmanager"
    grace    = 120
    timeout  = 60
    channels = ["discord", "webhook"]
    tags     = ["critical"]
  }
}
