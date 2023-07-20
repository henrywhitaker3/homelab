data "healthchecksio_channel" "email" {
  kind = "email"
}

data "healthchecksio_channel" "discord" {
  kind = "discord"
}

resource "healthchecksio_check" "speedtest" {
  name = "Speedtest"

  grace   = 300 # seconds
  timeout = 14400

  channels = [
    data.healthchecksio_channel.discord.id,
  ]
}

resource "healthchecksio_check" "jump_k8s_lan" {
  name = "K8s Jump server lan access"
  desc = "Checks the k8s jump server has access to home lan"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
    data.healthchecksio_channel.email.id,
  ]
}

resource "healthchecksio_check" "vpn_1" {
  name = "VPN 1"
  desc = "Checks the vpn interface is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
    data.healthchecksio_channel.email.id,
  ]
}

resource "healthchecksio_check" "vpn_2" {
  name = "VPN 2"
  desc = "Checks the vpn interface is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
    data.healthchecksio_channel.email.id,
  ]
}

resource "healthchecksio_check" "lb_1" {
  name = "LB 1"
  desc = "Checks the lb host is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
  ]
}

resource "healthchecksio_check" "lb_2" {
  name = "LB 2"
  desc = "Checks the lb host is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
  ]
}

resource "healthchecksio_check" "k3s_worker" {
  count = 2

  name = "k3s-worker-${count.index + 1}"
  desc = "Checks the k8s worker node is up"

  tags = [
    "k8s"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
  ]
}

resource "healthchecksio_check" "k3s_control" {
  count = 3

  name = "k3s-control-${count.index + 1}"
  desc = "Checks the k3s control node is up"

  tags = [
    "k3s"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"

  channels = [
    data.healthchecksio_channel.discord.id,
  ]
}
