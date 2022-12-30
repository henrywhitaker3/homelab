resource "healthchecksio_check" "docker" {
  name = "Docker"

  tags = [
    "docker"
  ]

  grace    = 360 # seconds
  schedule = "*/2 * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "docker_backup" {
  name = "Docker backup"

  tags = [
    "docker",
    "backup"
  ]

  grace    = 3600 # seconds
  timeout = 604800
}

resource "healthchecksio_check" "speedtest" {
  name = "Speedtest"

  grace    = 300 # seconds
  timeout = 14400
}

resource "healthchecksio_check" "jump_connection" {
  name = "Jump server vpn"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "jump_lan" {
  name = "Jump server lan access"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "vpn_1" {
  name = "VPN 1"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}

resource "healthchecksio_check" "vpn_2" {
  name = "VPN 2"

  tags = [
    "vpn"
  ]

  grace    = 60 # seconds
  schedule = "* * * * *"
  timezone = "UTC"
}
