locals {
  oncall_users = {
    henry = "henrywhitaker3"
  }

  oncall_shifts = {
    default = {
      name          = "Default"
      type          = "rolling_users"
      start         = "2024-11-18T00:00:00"
      duration      = 60 * 60 * 24
      frequency     = "daily"
      interval      = 1
      rolling_users = ["henry"]
    }
  }

  oncall_schedules = {
    default = {
      name                 = "Default"
      type                 = "calendar"
      enable_web_overrides = true
      shifts               = ["default"]
    }
  }

  oncall_intergations = {
    homelab_alertmanager = {
      name = "Homelab"
      type = "alertmanager"
    }
    cronitor = {
      name = "Cronitor"
      type = "webhook"
      templates = {
        grouping_key   = "{{ payload.id }}"
        resolve_signal = "{{ payload.get(\"type\", \"\") == \"Recovery\" }}"
        web = {
          title   = "Cronitor - {{ payload.monitor }}"
          message = "{{ payload.issue }}\\n{{ payload.description }}"
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
      query                = "{{ payload.type == \"Alert\" }}"
      type                 = "jinja2"
      position             = 0
    }
  }
}

data "grafana_oncall_user" "this" {
  for_each = local.oncall_users
  provider = grafana.oncall
  username = each.value
}

resource "grafana_oncall_schedule" "this" {
  for_each = local.oncall_schedules
  provider = grafana.oncall

  name      = each.value.name
  type      = each.value.type
  time_zone = lookup(each.value, "timezone", "Europe/London")
  shifts = [
    for shift in lookup(each.value, "shifts", []) : grafana_oncall_on_call_shift.this[shift].id
  ]
  enable_web_overrides = lookup(each.value, "enabled_web_overrides", false)
}

resource "grafana_oncall_on_call_shift" "this" {
  for_each = local.oncall_shifts
  provider = grafana.oncall

  name      = each.value.name
  type      = each.value.type
  start     = each.value.start
  frequency = each.value.frequency
  interval  = each.value.interval
  duration  = each.value.duration
  rolling_users = [
    [for user in lookup(each.value, "rolling_users", []) : data.grafana_oncall_user.this[user].id]
  ]
  users = [
    for user in lookup(each.value, "users", []) : data.grafana_oncall_user.this[user].id
  ]
}

resource "grafana_oncall_integration" "this" {
  for_each = local.oncall_intergations
  provider = grafana.oncall

  name = each.value.name
  type = each.value.type

  default_route {}

  dynamic "templates" {
    for_each = lookup(each.value, "templates", null) != null ? { main = each.value.templates } : {}

    content {
      grouping_key   = lookup(templates.value, "grouping_key", null)
      resolve_signal = lookup(templates.value, "resolve_signal", null)

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
    }
  }
}

resource "grafana_oncall_escalation_chain" "this" {
  for_each = local.oncall_escalation_chains
  provider = grafana.oncall

  name = each.value.name
}

resource "grafana_oncall_escalation" "this" {
  for_each = local.oncall_escalations
  provider = grafana.oncall

  escalation_chain_id          = grafana_oncall_escalation_chain.this[each.value.chain_key].id
  type                         = each.value.type
  position                     = each.value.position
  notify_on_call_from_schedule = lookup(each.value, "schedule_key", null) != null ? grafana_oncall_schedule.this[each.value.schedule_key].id : null
  duration                     = lookup(each.value, "duration", null)
  important                    = lookup(each.value, "important", null)
}

resource "grafana_oncall_route" "this" {
  for_each = local.oncall_routes
  provider = grafana.oncall

  integration_id      = grafana_oncall_integration.this[each.value.integration_key].id
  escalation_chain_id = grafana_oncall_escalation_chain.this[each.value.escalation_chain_key].id
  routing_regex       = each.value.query
  routing_type        = lookup(each.value, "type", "regex")
  position            = each.value.position
}
