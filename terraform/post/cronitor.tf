locals {
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
    }
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
    }
  }

  cronitor_heartbeat_monitors = {
    alertmanager = {
      name     = "Alertmanager"
      schedule = "* * * * *"
      grace_seconds = 10
      schedule_tolerance = 2
      timezone = "UTC"
    }
  }
}

resource "cronitor_http_monitor" "this" {
  for_each = local.cronitor_http_monitors

  name               = each.value.name
  schedule           = each.value.schedule
  url                = each.value.url
  method             = lookup(each.value, "method", "GET")
  assertions         = lookup(each.value, "assertions", null)
  grace_seconds      = lookup(each.value, "grace_seconds", null)
  failure_tolerance  = lookup(each.value, "failure_tolerance", null)
  schedule_tolerance = lookup(each.value, "schedule_tolerance", null)
  realert_interval   = lookup(each.value, "realert_interval", null)
  paused             = lookup(each.value, "paused", null)
  disabled           = lookup(each.value, "disabled", null)
  notify             = lookup(each.value, "notify", null)
  environments       = lookup(each.value, "environments", null)
  tags               = lookup(each.value, "tags", null)
  timeout_seconds    = lookup(each.value, "timeout_seconds", null)
  headers            = lookup(each.value, "headers", null)
  cookies            = lookup(each.value, "cookies", null)
  regions            = lookup(each.value, "regions", null)
  verify_ssl         = lookup(each.value, "verify_ssl", null)
  follow_redirects   = lookup(each.value, "follow_redirects", null)
  timezone           = lookup(each.value, "timezone", null)
  body               = lookup(each.value, "body", null)
}

resource "cronitor_heartbeat_monitor" "this" {
  for_each = local.cronitor_heartbeat_monitors

  name               = each.value.name
  schedule           = each.value.schedule
  grace_seconds      = lookup(each.value, "grace_seconds", null)
  schedule_tolerance = lookup(each.value, "schedule_tolerance", null)
  failure_tolerance  = lookup(each.value, "failure_tolerance", null)
  realert_interval   = lookup(each.value, "realert_interval", null)
  paused             = lookup(each.value, "paused", null)
  disabled           = lookup(each.value, "disabled", null)
  notify             = lookup(each.value, "notify", null)
  environments       = lookup(each.value, "environments", null)
  tags               = lookup(each.value, "tags", null)
  timezone           = lookup(each.value, "timezone", null)
}
