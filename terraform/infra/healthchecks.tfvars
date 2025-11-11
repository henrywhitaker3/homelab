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
  k3s_control_1 = {
    name     = "k3s-control-1"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["critical", "k3s"]
  }
  k3s_control_2 = {
    name     = "k3s-control-2"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["critical", "k3s"]
  }
  k3s_control_3 = {
    name     = "k3s-control-3"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["critical", "k3s"]
  }
  k3s_dedi_1 = {
    name     = "k3s-dedi-1"
    grace    = 120
    schedule = "* * * * *"
    timezone = "UTC"
    channels = ["discord", "webhook"]
    tags     = ["critical", "k3s"]
  }
  alertmanager = {
    name     = "Alertmanager"
    grace    = 120
    timeout  = 60
    channels = ["discord", "webhook"]
    tags     = ["critical"]
  }
}
