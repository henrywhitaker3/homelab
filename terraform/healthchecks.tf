resource "healthchecksio_check" "docker" {
  name = "Docker"
  desc = "Docker host up/down"

  tags = [
    "docker"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "docker_backup" {
  name = "Docker backup"
  desc = "Weekly docker backup script"

  tags = [
    "docker",
    "backup"
  ]

  grace   = 3600 # seconds
  schedule = "30 4 * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "speedtest" {
  name = "Speedtest"

  grace   = 300 # seconds
  timeout = 14400
}

resource "healthchecksio_check" "jump_connection" {
  name = "Jump server vpn"
  desc = "Checks the vpn interface is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "jump_lan" {
  name = "Jump server lan access"
  desc = "Checks the jump server has access to home lan"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "jump_k8s_connection" {
  name = "K8s Jump server vpn"
  desc = "Checks the vpn interface is up"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
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
}
