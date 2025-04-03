cronitor_http_monitors = {
  plex = {
    name     = "Plex"
    url      = "https://plex.plexmox.com"
    schedule = "every 5 minutes"
    assertions = [
      "response.code = 401"
    ]
    failure_tolerance = 1
    regions = [
      "eu-west-1",
      "eu-central-1",
    ]
    notify = [
      "grafana"
    ]
  },
  status = {
    name     = "Status Page"
    url      = "https://status.henrywhitaker.com"
    schedule = "every 5 minutes"
    assertions = [
      "response.code = 200"
    ]
    failure_tolerance = 1
    regions = [
      "eu-west-1",
      "eu-central-1",
    ]
    notify = [
      "grafana"
    ]
  }
}

cronitor_heartbeat_monitors = {
  alertmanager = {
    name               = "Alertmanager"
    schedule           = "* * * * *"
    grace_seconds      = 10
    schedule_tolerance = 2
    timezone           = "UTC"
    notify = [
      "grafana"
    ]
  }
}

cronitor_notification_lists = {
  grafana = {
    name = "Grafana"
    webhooks = [
      "grafana-oncall",
    ]
  }
}
