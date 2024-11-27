locals {
  oncall_users = {
    henry = "henrywhitaker3"
    none  = "noneuser"
  }

  oncall_shifts = {
    default = {
      name          = "Default"
      type          = "rolling_users"
      start         = "2024-11-18T08:00:00"
      duration      = 60 * 60 * 16
      by_day        = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
      frequency     = "weekly"
      week_start    = "MO"
      interval      = 1
      rolling_users = ["henry"]
    }
    none = {
      name          = "None"
      type          = "rolling_users"
      start         = "2024-11-18T00:00:00"
      duration      = (60 * 60 * 8)
      by_day        = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
      frequency     = "weekly"
      week_start    = "MO"
      interval      = 1
      rolling_users = ["none"]
    }
  }

  oncall_schedules = {
    default = {
      name                 = "Default"
      type                 = "calendar"
      enable_web_overrides = true
      shifts               = ["default", "none"]
    }
  }

  oncall_intergations = {
    homelab_alertmanager = {
      name = "Homelab"
      type = "alertmanager"
    }
    healthchecks = {
      name = "Healthchecks.io"
      type = "webhook"
      templates = {
        grouping_key   = "{{ payload.check.uuid }}"
        resolve_signal = "{{ payload.status == \"up\" }}"
        source_link    = "https://healthchecks.io/checks/{{ payload.check.uuid }}/details"
        web = {
          title   = "Healthchecks - {{ payload.check.name }}"
          message = "Healthchecks.io check {{ payload.check.name }} is {{ payload.status }}"
        }
        mobile_app = {
          title   = "Healthchecks - {{ payload.check.name }}"
          message = "Healthchecks.io check {{ payload.check.name }} is {{ payload.status }}"
        }
        sms = {
          title = "Healthchecks - {{ payload.check.name }}"
        }
        phone_call = {
          title = "Healthchecks - {{ payload.check.name }}"
        }
      }
    }
    cronitor = {
      name = "Cronitor"
      type = "webhook"
      templates = {
        grouping_key   = "{{ payload.id }}"
        resolve_signal = "{{ payload.get(\"type\", \"\") == \"Recovery\" }}"
        source_link    = "{{ payload.issue_url }}"
        web = {
          title   = "Cronitor - {{ payload.monitor }}"
          message = "{{ payload.issue }}\n{{ payload.description }}"
        }
        mobile_app = {
          title   = "Cronitor - {{ payload.monitor }}"
          message = "{{ payload.issue }}\n{{ payload.description }}"
        }
        sms = {
          title = "Cronitor - {{ payload.monitor }}"
        }
        phone_call = {
          title = "Cronitor - {{ payload.monitor }}"
        }
      }
    }
  }

  oncall_escalation_chains = {
    critical = {
      name = "Critical"
    }
    warning = {
      name = "Warning"
    }
  }

  oncall_escalations = {
    critical_notify = {
      chain_key    = "critical"
      type         = "notify_on_call_from_schedule"
      schedule_key = "default"
      important    = true
      position     = 0
    }
    critical_wait = {
      chain_key = "critical"
      type      = "wait"
      duration  = 60 * 60
      position  = 1
    }
    critical_renotify = {
      chain_key = "critical"
      type      = "repeat_escalation"
      position  = 2
    }
    warning_notify = {
      chain_key    = "warning"
      type         = "notify_on_call_from_schedule"
      schedule_key = "default"
      position     = 0
    }
  }

  oncall_routes = {
    critical = {
      integration_key      = "homelab_alertmanager"
      escalation_chain_key = "critical"
      query                = "{{ payload.commonLabels.severity == \"critical\" }}"
      type                 = "jinja2"
      position             = 0
    }
    warning = {
      integration_key      = "homelab_alertmanager"
      escalation_chain_key = "warning"
      query                = "{{ payload.commonLabels.severity == \"warning\" }}"
      type                 = "jinja2"
      position             = 1
    }
    cronitor_critical = {
      integration_key      = "cronitor"
      escalation_chain_key = "critical"
      query                = "{{ payload.type in [\"Alert\", \"Recovery\"] }}"
      type                 = "jinja2"
      position             = 0
    }
    healthchecks_warning = {
      integration_key      = "healthchecks"
      escalation_chain_key = "warning"
      query                = "{{ \"warning\" in payload.check.tags }}"
      type                 = "jinja2"
      position             = 0
    }
    healthchecks_critical = {
      integration_key      = "healthchecks"
      escalation_chain_key = "critical"
      query                = "{{ \"critical\" in payload.check.tags }}"
      type                 = "jinja2"
      position             = 1
    }
  }

  synthetic_tests = {}
}

data "grafana_oncall_user" "this" {
  for_each = local.oncall_users
  username = each.value
}

resource "grafana_oncall_schedule" "this" {
  for_each = local.oncall_schedules

  name      = each.value.name
  type      = each.value.type
  time_zone = lookup(each.value, "timezone", "Europe/London")
  shifts = [
    for shift in lookup(each.value, "shifts", []) : grafana_oncall_on_call_shift.this[shift].id
  ]
  enable_web_overrides = lookup(each.value, "enable_web_overrides", false)
}

resource "grafana_oncall_on_call_shift" "this" {
  for_each = local.oncall_shifts

  name                           = each.value.name
  type                           = each.value.type
  start                          = each.value.start
  frequency                      = each.value.frequency
  interval                       = each.value.interval
  duration                       = each.value.duration
  week_start                     = lookup(each.value, "week_start", null)
  by_day                         = lookup(each.value, "by_day", null)
  start_rotation_from_user_index = each.value.type == "rolling_users" ? 0 : null
  rolling_users = [
    [for user in lookup(each.value, "rolling_users", []) : data.grafana_oncall_user.this[user].id]
  ]
  users = [
    for user in lookup(each.value, "users", []) : data.grafana_oncall_user.this[user].id
  ]
}

resource "grafana_oncall_integration" "this" {
  for_each = local.oncall_intergations

  name = each.value.name
  type = each.value.type

  default_route {}

  dynamic "templates" {
    for_each = lookup(each.value, "templates", null) != null ? { main = each.value.templates } : {}

    content {
      grouping_key   = lookup(templates.value, "grouping_key", null)
      resolve_signal = lookup(templates.value, "resolve_signal", null)
      source_link    = lookup(templates.value, "source_link", null)

      dynamic "web" {
        for_each = lookup(templates.value, "web", null) != null ? { main = templates.value.web } : {}

        content {
          title   = lookup(web.value, "title", null)
          message = lookup(web.value, "message", null)
        }
      }
      dynamic "sms" {
        for_each = lookup(templates.value, "sms", null) != null ? { main = templates.value.sms } : {}

        content {
          title = lookup(sms.value, "title", null)
        }
      }
      dynamic "phone_call" {
        for_each = lookup(templates.value, "phone_call", null) != null ? { main = templates.value.phone_call } : {}

        content {
          title = lookup(phone_call.value, "title", null)
        }
      }
      dynamic "mobile_app" {
        for_each = lookup(templates.value, "mobile_app", null) != null ? { main = templates.value.mobile_app } : {}
        content {
          title   = lookup(mobile_app.value, "title", null)
          message = lookup(mobile_app.value, "message", null)
        }
      }
    }
  }
}

resource "grafana_oncall_escalation_chain" "this" {
  for_each = local.oncall_escalation_chains

  name = each.value.name
}

resource "grafana_oncall_escalation" "this" {
  for_each = local.oncall_escalations

  escalation_chain_id          = grafana_oncall_escalation_chain.this[each.value.chain_key].id
  type                         = each.value.type
  position                     = each.value.position
  notify_on_call_from_schedule = lookup(each.value, "schedule_key", null) != null ? grafana_oncall_schedule.this[each.value.schedule_key].id : null
  duration                     = lookup(each.value, "duration", null)
  important                    = lookup(each.value, "important", null)
}

resource "grafana_oncall_route" "this" {
  for_each = local.oncall_routes

  integration_id      = grafana_oncall_integration.this[each.value.integration_key].id
  escalation_chain_id = grafana_oncall_escalation_chain.this[each.value.escalation_chain_key].id
  routing_regex       = each.value.query
  routing_type        = lookup(each.value, "type", "regex")
  position            = each.value.position
}

data "grafana_synthetic_monitoring_probes" "this" {}

resource "grafana_synthetic_monitoring_check" "this" {
  for_each = local.synthetic_tests

  job               = each.value.name
  probes            = each.value.probes
  target            = each.value.target
  frequency         = each.value.frequency
  alert_sensitivity = lookup(each.value, "priority", null)
  enabled           = lookup(each.value, "enabled", true)

  settings {
    dynamic "http" {
      for_each = lookup(each.value.settings, "http", null) != null ? { main = each.value.settings.http } : {}
      content {
        method              = lookup(http.value, "method", null)
        valid_status_codes  = lookup(http.value, "valid_status_codes", null)
        no_follow_redirects = !lookup(http.value, "follow_redirects", true)

        dynamic "fail_if_header_not_matches_regexp" {
          for_each = lookup(http.value, "match_headers", {})
          content {
            header = fail_if_header_not_matches_regexp.value.name
            regexp = fail_if_header_not_matches_regexp.value.regex
          }
        }
      }
    }
  }
}
