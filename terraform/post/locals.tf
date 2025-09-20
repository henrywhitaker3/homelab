locals {
  vm_info = concat(
    data.terraform_remote_state.infra.outputs.adguard_info,
    data.terraform_remote_state.infra.outputs.minio_info,
    data.terraform_remote_state.infra.outputs.lb_info,
    data.terraform_remote_state.infra.outputs.k3s_control_info,
    data.terraform_remote_state.infra.outputs.k3s_dedi_info,
    [{ name = "jump", ip = "10.8.0.1" }],
    [{ name = "minio", ip = "10.0.0.6" }],
    [{ name = "unraid", ip = "10.0.0.9" }],
    [{ name = "proxmox-1", ip = "10.0.0.150" }],
    [{ name = "proxmox-2", ip = "10.0.0.152" }],
    [{ name = "proxmox-3", ip = "10.0.0.154" }],
    [{ name = "mac-mini", ip = "10.0.0.54" }],
    [{ name = "jetkvm", ip = "10.0.0.62" }],
    [
      for key, value in local.netbird_peers : {
        name = format("%s.netbird", key)
        ip   = data.netbird_peer.this[key].ip
      }
    ],
  )

  dhcp_static_leases = [
    {
      mac      = "2c:f0:5d:75:f1:ba"
      ip       = "10.0.0.226"
      hostname = "desktop-ogovugk"
    },
    {
      mac      = "dc:a6:32:16:b4:d4"
      ip       = "10.0.0.139"
      hostname = "living-room"
    },
    {
      mac      = "18:2f:a3:3e:dc:7a"
      ip       = "10.0.0.30"
      hostname = "mango-control-1"
    },
    {
      mac      = "18:88:df:e6:c2:99"
      ip       = "10.0.0.31"
      hostname = "mango-control-2"
    },
    {
      mac      = "18:e7:3e:fa:e1:f9"
      ip       = "10.0.0.32"
      hostname = "mango-control-3"
    },
    {
      mac      = "12:d3:a8:a1:99:54"
      ip       = "10.0.0.54"
      hostname = "mac-mini"
    },
    {
      mac      = "44:b7:d0:e2:83:63"
      ip       = "10.0.0.62"
      hostname = "jetkvm"
    },
  ]

  dhcp_ipv4_settings = {
    gateway_ip     = "10.0.0.1"
    lease_duration = 86400
    range_start    = "10.0.0.41"
    range_end      = "10.0.0.251"
    subnet_mask    = "255.255.255.0"
  }

  internal_ingress = [
    "unraid.plexmox.com",
    "minio.plexmox.com",
    "s3.plexmox.com",
    "prometheus.plexmox.com",
    "alerts.plexmox.com",
    "longhorn.plexmox.com",
    "grafana.plexmox.com",
    "maxscale.plexmox.com",
    "thanos.plexmox.com",
    "proxmox.plexmox.com",
    "speedtest.plexmox.com",
    "loki.plexmox.com",
    "harbor.plexmox.com",
    "orderly.henrywhitaker.com",
    "victoria.plexmox.com",
    "victoria-logs.plexmox.com",
    "garage.plexmox.com",
    "garage-web.plexmox.com",
    "garage-admin.plexmox.com",
    "garage-webui.plexmox.com",
    "immich.plexmox.com",
  ]

  upstream_dns = [
    "https://cloudflare-dns.com/dns-query",
    "https://dns10.quad9.net/dns-query"
  ]

  bootstrap_dns = [
    "9.9.9.10",
    "149.112.112.10",
    "2620:fe::10",
    "2620:fe::fe:10",
  ]

  custom_rewrites = [
    {
      src  = "orderly.dev"
      dest = "127.0.0.1"
    },
    {
      src  = "*.orderly.dev"
      dest = "127.0.0.1"
    },
  ]

  filter_lists = [
    {
      name = "AdGuard DNS Filter"
      url  = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
    },
    {
      name = "AdGuard Default Blocklist",
      url  = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt"
    }
  ]
}
