resource "adguard_config" "config" {
  # provider = var.provider

  safesearch = {
    enabled = var.safesearch_enabled
  }

  querylog = {
    enabled  = var.query_log_enabled
    interval = var.query_log_interval
  }

  stats = {
    enabled  = var.stats_enabled
    interval = var.stats_interval
  }

  dns = {
    upstream_dns  = var.upstream_dns
    bootstrap_dns = var.bootstrap_dns
    rate_limit    = var.dns_rate_limit
  }

  dhcp = {
    enabled   = var.dhcp_enabled
    interface = var.dhcp_interface

    ipv4_settings = var.dhcp_ipv4_settings

    static_leases = var.dhcp_static_leases

    filtering = {
      enabled = var.filtering_enabled
    }
  }
}

resource "adguard_list_filter" "filters" {
  for_each = {
    for c in var.filter_lists :
    c.name => c
  }

  enabled = true
  name    = each.value.name
  url     = each.value.url
}

resource "adguard_rewrite" "vms" {
  for_each = {
    for value in var.vms : "${value.name}.lab" => value
  }

  domain = each.key
  answer = each.value.ip
}

resource "adguard_rewrite" "internal_ingress" {
  for_each = toset(var.internal_ingress_targets)

  domain = each.value
  answer = var.internal_ingress_ip
}

resource "adguard_rewrite" "custom_rewrites" {
  for_each = {
    for value in var.custom_rewrites : value.src => value
  }

  domain = each.key
  answer = each.value.dest
}

resource "adguard_user_rules" "this" {
  rules = var.filter_rules
}
