data "healthchecksio_channel" "discord" {
  kind = "discord"
}

data "healthchecksio_channel" "webhook" {
  kind = "webhook"
}

locals {
  healthchecks_channels = ["discord", "webhook"]

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
    vpn_1 = {
      name     = "VPN 1"
      grace    = 120
      schedule = "* * * * *"
      timezone = "UTC"
      channels = ["discord", "webhook"]
      tags     = ["critical", "vpn"]
    }
    vpn_2 = {
      name     = "VPN 2"
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
}

data "healthchecksio_channel" "this" {
  for_each = toset(local.healthchecks_channels)
  kind     = each.value
}

resource "healthchecksio_check" "this" {
  for_each = local.healthchecks_checks

  name     = each.value.name
  desc     = lookup(each.value, "desc", null)
  grace    = lookup(each.value, "grace", null)
  timeout  = lookup(each.value, "timeout", null)
  schedule = lookup(each.value, "schedule", null)
  timezone = lookup(each.value, "timezone", null)
  channels = lookup(each.value, "channels", null) == null ? null : [
    for key in each.value.channels : data.healthchecksio_channel.this[key].id
  ]
  tags = lookup(each.value, "tags", null)
}
