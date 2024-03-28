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
    upstream_dns = [
      "https://dns10.quad9.net/dns-query",
      "1.1.1.1"
    ]
    bootstrap_dns = [
      "9.9.9.10",
      "149.112.112.10",
      "2620:fe::10",
      "2620:fe::fe:10",
    ]
    rate_limit = 20
  }

  dhcp = {
    enabled   = true
    interface = "eth0"

    ipv4_settings = {
      gateway_ip     = "10.0.0.1"
      lease_duration = 86400
      range_start    = "10.0.0.31"
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
    upstream_dns = [
      "https://dns10.quad9.net/dns-query",
      "1.1.1.1"
    ]
    bootstrap_dns = [
      "9.9.9.10",
      "149.112.112.10",
      "2620:fe::10",
      "2620:fe::fe:10",
    ]
    rate_limit = 20
  }

  filtering = {
    enabled = true
  }
}

resource "adguard_list_filter" "dns_1" {
  provider = adguard.adguard-1
  enabled  = true
  name     = "AdGuard DNS filter"
  url      = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
}

resource "adguard_list_filter" "block_1" {
  provider = adguard.adguard-1
  enabled  = true
  name     = "AdGuard Default Blocklist"
  url      = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt"
}

resource "adguard_list_filter" "dns_2" {
  provider = adguard.adguard-2
  enabled  = true
  name     = "AdGuard DNS filter"
  url      = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
}

resource "adguard_list_filter" "block_2" {
  provider = adguard.adguard-2
  enabled  = true
  name     = "AdGuard Default Blocklist"
  url      = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt"
}
