variable "healthchecks_channels" {
  type = map(object({
    kind = string
  }))
  validation {
    condition = length([
      for key, value in var.healthchecks_channels : true
      if contains(["discord", "webhook"], value.kind)
    ]) == length(var.healthchecks_channels)
    error_message = "kind must be one of: discord, webhook"
  }
}

data "healthchecksio_channel" "this" {
  for_each = var.healthchecks_channels
  kind     = each.value.kind
}

variable "healthchecks_checks" {
  type = map(object({
    name     = string
    desc     = optional(string, null)
    grace    = optional(number, null)
    timeout  = optional(number, null)
    channels = optional(list(string), null)
    schedule = optional(string)
    timezone = optional(string)
    tags     = optional(list(string), null)
  }))
  validation {
    condition = length([
      for key, value in var.healthchecks_checks : true
      if value.channels == null ? true : length([
        for c_key, c_value in value.channels : true
        if contains(keys(var.healthchecks_channels), c_value)
      ]) == length(value.channels)
    ]) == length(var.healthchecks_checks)
    error_message = "channels must be defined in var.healthchecks_channels"
  }
}

resource "healthchecksio_check" "this" {
  for_each = var.healthchecks_checks

  name     = each.value.name
  desc     = lookup(each.value, "desc", null)
  grace    = lookup(each.value, "grace", null)
  timeout  = lookup(each.value, "timeout", null)
  schedule = lookup(each.value, "schedule", null)
  timezone = lookup(each.value, "timezone", null)
  channels = lookup(each.value, "channels", null) == null ? null : [
    for key in each.value.channels : data.healthchecksio_channel.this[key].id
  ]
  tags = lookup(each.value, "tags", null)
}
