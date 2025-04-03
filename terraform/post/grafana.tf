data "grafana_oncall_user" "this" {
  for_each = var.oncall_users
  username = each.value
}

resource "grafana_oncall_schedule" "this" {
  for_each = var.oncall_schedules

  name      = each.value.name
  type      = each.value.type
  time_zone = lookup(each.value, "timezone", "Europe/London")
  shifts = [
    for shift in lookup(each.value, "shifts", []) : grafana_oncall_on_call_shift.this[shift].id
  ]
  enable_web_overrides = lookup(each.value, "enable_web_overrides", false)
}

resource "grafana_oncall_on_call_shift" "this" {
  for_each = var.oncall_shifts

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
  for_each = var.oncall_intergations

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
  for_each = var.oncall_escalation_chains

  name = each.value.name
}

resource "grafana_oncall_escalation" "this" {
  for_each = var.oncall_escalations

  escalation_chain_id          = grafana_oncall_escalation_chain.this[each.value.chain_key].id
  type                         = each.value.type
  position                     = each.value.position
  notify_on_call_from_schedule = lookup(each.value, "schedule_key", null) != null ? grafana_oncall_schedule.this[each.value.schedule_key].id : null
  duration                     = lookup(each.value, "duration", null)
  important                    = lookup(each.value, "important", null)
}

resource "grafana_oncall_route" "this" {
  for_each = var.oncall_routes

  integration_id      = grafana_oncall_integration.this[each.value.integration_key].id
  escalation_chain_id = grafana_oncall_escalation_chain.this[each.value.escalation_chain_key].id
  routing_regex       = each.value.query
  routing_type        = lookup(each.value, "type", "regex")
  position            = each.value.position
}

variable "oncall_users" {
  type    = map(string)
  default = {}
}

variable "oncall_shifts" {
  type = map(object({
    name          = string
    type          = string
    start         = string
    duration      = number
    by_day        = list(string)
    frequency     = string
    week_start    = string
    interval      = number
    rolling_users = optional(list(string), null)
  }))
  validation {
    condition = length([
      for key, value in var.oncall_shifts : true
      if contains(["rolling_users"], value.type)
    ]) == length(var.oncall_shifts)
    error_message = "type must be one of: rolling_users"
  }
  validation {
    condition = length([
      for key, value in var.oncall_shifts : true
      if can(regex("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}", value.start))
    ]) == length(var.oncall_shifts)
    error_message = "start must be an iso date"
  }
  validation {
    condition = length([
      for key, value in var.oncall_shifts : true
      if length([
        for b_key, b_value in value.by_day : true
        if contains(["MO", "TU", "WE", "TH", "FR", "SA", "SU"], b_value)
      ]) == length(value.by_day)
    ]) == length(var.oncall_shifts)
    error_message = "by_day must be one of: MO, TU, WE, TH, FR, SA, SU"
  }
  validation {
    condition = length([
      for key, value in var.oncall_shifts : true
      if contains(["MO", "TU", "WE", "TH", "FR", "SA", "SU"], value.week_start)
    ]) == length(var.oncall_shifts)
    error_message = "week_start must be one of: MO, TU, WE, TH, FR, SA, SU"
  }
  validation {
    condition = length([
      for key, value in var.oncall_shifts : true
      if value.rolling_users == null || length([
        for r_key, r_value in value.rolling_users : true
        if contains(keys(var.oncall_users), r_value)
      ]) == length(value.rolling_users)
    ]) == length(var.oncall_shifts)
    error_message = "All users must be defined in var.rolling_users"
  }
}

variable "oncall_schedules" {
  type = map(object({
    name                 = string
    type                 = string
    enable_web_overrides = optional(bool, null)
    shifts               = list(string)
  }))
  validation {
    condition = length([
      for key, value in var.oncall_schedules : true
      if contains(["calendar"], value.type)
    ]) == length(var.oncall_schedules)
    error_message = "type must be one of: calendar"
  }
  validation {
    condition = length([
      for key, value in var.oncall_schedules : true
      if length([
        for s_key, s_value in value.shifts : true
        if contains(keys(var.oncall_shifts), s_value)
      ]) == length(value.shifts)
    ]) == length(var.oncall_schedules)
    error_message = "All shifts must be defined in var.oncall_shifts"
  }
}

variable "oncall_intergations" {
  type = map(object({
    name = string
    type = string
    templates = optional(object({
      grouping_key   = string
      resolve_signal = string
      source_link    = string
      web = optional(object({
        title   = string
        message = optional(string)
      }), null)
      mobile_app = optional(object({
        title   = string
        message = optional(string)
      }), null)
      sms = optional(object({
        title   = string
        message = optional(string)
      }), null)
      phone_call = optional(object({
        title   = string
        message = optional(string)
      }), null)
    }), null)
  }))
}

variable "oncall_escalation_chains" {
  type = map(object({
    name = string
  }))
}

variable "oncall_escalations" {
  type = map(object({
    chain_key    = string
    type         = string
    schedule_key = optional(string, null)
    important    = optional(bool, false)
    duration     = optional(number, null)
    position     = number
  }))
  validation {
    condition = length([
      for key, value in var.oncall_escalations : true
      if contains(keys(var.oncall_escalation_chains), value.chain_key)
    ]) == length(var.oncall_escalations)
    error_message = "chain_key must be defined in var.oncall_escalation_chains"
  }
  validation {
    condition = length([
      for key, value in var.oncall_escalations : true
      if value.schedule_key == null ? true : contains(keys(var.oncall_schedules), value.schedule_key)
    ]) == length(var.oncall_escalations)
    error_message = "schedule_key must be defined in var.oncall_schedules"
  }
  validation {
    condition = length([
      for key, value in var.oncall_escalations : true
      if contains(["notify_on_call_from_schedule", "wait", "repeat_escalation"], value.type)
    ]) == length(var.oncall_escalations)
    error_message = "type must be one of: notify_on_call_from_schedule, wait, repeat_escalation"
  }
}

variable "oncall_routes" {
  type = map(object({
    integration_key      = string
    escalation_chain_key = string
    query                = string
    type                 = string
    position             = number
  }))
  validation {
    condition = length([
      for key, value in var.oncall_routes : true
      if contains(keys(var.oncall_intergations), value.integration_key)
    ]) == length(var.oncall_routes)
    error_message = "integration_key must be defined in var.oncall_intergations"
  }
  validation {
    condition = length([
      for key, value in var.oncall_routes : true
      if contains(keys(var.oncall_escalation_chains), value.escalation_chain_key)
    ]) == length(var.oncall_routes)
    error_message = "escalation_chain_key must be defined in var.oncall_escalation_chains"
  }
  validation {
    condition = length([
      for key, value in var.oncall_routes : true
      if contains(["jinja2"], value.type)
    ]) == length(var.oncall_routes)
    error_message = "type must be one of: jinja2"
  }
}
