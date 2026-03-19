data "uptimekuma_tag" "this" {
  for_each = {
    auth  = { name = "auth" }
    media = { name = "media" }
    infra = { name = "infra" }
    db    = { name = "db" }
  }

  name = each.value.name
}

data "uptimekuma_notification_discord" "this" {
  for_each = {
    discord = { name = "Discord #uptime" }
  }

  name = each.value.name
}

variable "http_monitors" {
  type = map(object({
    name          = string
    url           = string
    interval      = optional(number, 60)
    timeout       = optional(number, 30)
    max_retries   = optional(number, 0)
    active        = optional(bool, true)
    status_codes  = optional(list(string), ["200-299"])
    max_redirects = optional(number, 10)
    channels      = optional(list(string), ["discord"])
    headers       = optional(map(string), null)
    tags          = optional(list(string), [])
  }))
  default = {}
}

resource "uptimekuma_monitor_http" "this" {
  for_each = var.http_monitors

  name                  = each.value.name
  url                   = each.value.url
  interval              = each.value.interval
  timeout               = each.value.timeout
  max_retries           = each.value.max_retries
  max_redirects         = each.value.max_redirects
  accepted_status_codes = each.value.status_codes
  active                = each.value.active
  headers = (
    each.value.headers == null ?
    null :
    jsonencode(each.value.headers)
  )
  notification_ids = [
    for name in each.value.channels : try(
      data.uptimekuma_notification_discord.this[name].id
    )
  ]
  tags = [
    for tag in each.value.tags : {
      tag_id = data.uptimekuma_tag.this[tag].id
    }
  ]
}

variable "redis_monitors" {
  type = map(object({
    name     = string
    url      = string
    interval = optional(number, 30)
    channels = optional(list(string), ["discord"])
    tags     = optional(list(string), [])
    active   = optional(bool, true)
  }))
  default = {}
}

resource "uptimekuma_monitor_redis" "this" {
  for_each = var.redis_monitors

  name                       = each.value.name
  database_connection_string = each.value.url
  interval                   = each.value.interval
  active                     = each.value.active
  notification_ids = [
    for name in each.value.channels : try(
      data.uptimekuma_notification_discord.this[name].id
    )
  ]
  tags = [
    for tag in each.value.tags : {
      tag_id = data.uptimekuma_tag.this[tag].id
    }
  ]
}

variable "tcp_monitors" {
  type = map(object({
    name     = string
    host     = string
    port     = number
    interval = optional(number, 30)
    active   = optional(bool, true)
    channels = optional(list(string), ["discord"])
    tags     = optional(list(string), [])
  }))
  default = {}
}

resource "uptimekuma_monitor_tcp_port" "this" {
  for_each = var.tcp_monitors

  name     = each.value.name
  hostname = each.value.host
  port     = each.value.port
  interval = each.value.interval
  active   = each.value.active
  notification_ids = [
    for name in each.value.channels : try(
      data.uptimekuma_notification_discord.this[name].id
    )
  ]
  tags = [
    for tag in each.value.tags : {
      tag_id = data.uptimekuma_tag.this[tag].id
    }
  ]
}
