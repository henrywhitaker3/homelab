variable "cronitor_http_monitors" {
  type = map(object({
    name              = string
    url               = string
    schedule          = string
    assertions        = list(string)
    failure_tolerance = optional(number, null)
    regions           = list(string)
    notify            = optional(list(string), null)
  }))
  validation {
    condition = length([
      for key, value in var.cronitor_http_monitors : true
      if value.notify == null ? true : length([
        for n_key, n_value in value.notify : true
        if contains(keys(var.cronitor_notification_lists), n_value)
      ]) == length(value.notify)
    ]) == length(var.cronitor_http_monitors)
    error_message = "notify must be defined in var.cronitor_notification_lists"
  }
}

variable "cronitor_notification_lists" {
  type = map(object({
    name     = string
    webhooks = list(string)
  }))
}

variable "cronitor_heartbeat_monitors" {
  type = map(object({
    name               = string
    schedule           = string
    grace_seconds      = number
    schedule_tolerance = number
    timezone           = optional(string, "UTC")
    notify             = optional(list(string), null)
  }))
  validation {
    condition = length([
      for key, value in var.cronitor_heartbeat_monitors : true
      if value.notify == null ? true : length([
        for n_key, n_value in value.notify : true
        if contains(keys(var.cronitor_notification_lists), n_value)
      ]) == length(value.notify)
    ]) == length(var.cronitor_heartbeat_monitors)
    error_message = "notify must be defined in var.cronitor_notification_lists"
  }
}

resource "cronitor_http_monitor" "this" {
  for_each = var.cronitor_http_monitors

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
  notify = lookup(each.value, "notify", null) == null ? null : [
    for key, value in each.value.notify : cronitor_notification_list.this[value].key
  ]
  environments     = lookup(each.value, "environments", null)
  tags             = lookup(each.value, "tags", null)
  timeout_seconds  = lookup(each.value, "timeout_seconds", null)
  headers          = lookup(each.value, "headers", null)
  cookies          = lookup(each.value, "cookies", null)
  regions          = lookup(each.value, "regions", null)
  verify_ssl       = lookup(each.value, "verify_ssl", null)
  follow_redirects = lookup(each.value, "follow_redirects", null)
  timezone         = lookup(each.value, "timezone", null)
  body             = lookup(each.value, "body", null)
}

resource "cronitor_heartbeat_monitor" "this" {
  for_each = var.cronitor_heartbeat_monitors

  name               = each.value.name
  schedule           = each.value.schedule
  grace_seconds      = lookup(each.value, "grace_seconds", null)
  schedule_tolerance = lookup(each.value, "schedule_tolerance", null)
  failure_tolerance  = lookup(each.value, "failure_tolerance", null)
  realert_interval   = lookup(each.value, "realert_interval", null)
  paused             = lookup(each.value, "paused", null)
  disabled           = lookup(each.value, "disabled", null)
  notify = lookup(each.value, "notify", null) == null ? null : [
    for key, value in each.value.notify : cronitor_notification_list.this[value].key
  ]
  environments = lookup(each.value, "environments", null)
  tags         = lookup(each.value, "tags", null)
  timezone     = lookup(each.value, "timezone", null)
}

resource "cronitor_notification_list" "this" {
  for_each = var.cronitor_notification_lists

  name      = each.value.name
  emails    = lookup(each.value, "emails", null)
  slack     = lookup(each.value, "slack", null)
  pagerduty = lookup(each.value, "pagerduty", null)
  phones    = lookup(each.value, "phones", null)
  webhooks  = lookup(each.value, "webhooks", null)
}
