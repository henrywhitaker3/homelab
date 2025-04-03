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
