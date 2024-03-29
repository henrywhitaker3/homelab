resource "adguard_config" "primary" {
  provider = adguard.adguard-1

  safesearch = {
    enabled = false
  }

  querylog = {
    enabled  = true
    interval = 30
  }

  stats = {
    enabled  = true
    interval = 24
  }

  dns = {
    upstream_dns = local.upstream_dns
    bootstrap_dns = local.bootstrap_dns
    rate_limit = 20
  }

  dhcp = {
    enabled   = true
    interface = "eth0"

    ipv4_settings = {
      gateway_ip     = "10.0.0.1"
      lease_duration = 86400
      range_start    = "10.0.0.41"
      range_end      = "10.0.0.251"
      subnet_mask    = "255.255.255.0"
    }

    static_leases = [
      {
        mac      = "2c:f0:5d:75:f1:ba"
        ip       = "10.0.0.226"
        hostname = "desktop-ogovugk"
      },
      {
        mac      = "dc:a6:32:16:b4:d4"
        ip       = "10.0.0.139"
        hostname = "living-room"
      }
    ]
  }

  filtering = {
    enabled = true
  }
}

resource "adguard_config" "secondary" {
  provider = adguard.adguard-2

  safesearch = {
    enabled = false
  }

  querylog = {
    enabled  = true
    interval = 30
  }

  stats = {
    enabled  = true
    interval = 24
  }

  dns = {
    upstream_dns = local.upstream_dns
    bootstrap_dns = local.bootstrap_dns
    rate_limit = 20
  }

  filtering = {
    enabled = true
  }
}

resource "adguard_list_filter" "filters_1" {
  provider = adguard.adguard-1
  for_each = {
    for c in local.filter_lists:
    c.name => c
  }

  enabled  = true
  name     = each.value.name
  url      = each.value.url
}

resource "adguard_list_filter" "filters_2" {
  provider = adguard.adguard-2
  for_each = {
    for c in local.filter_lists:
    c.name => c
  }

  enabled  = true
  name     = each.value.name
  url      = each.value.url
}
