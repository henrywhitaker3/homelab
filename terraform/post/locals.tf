locals {
  vm_info = concat(
    data.terraform_remote_state.infra.outputs.adguard_info,
    data.terraform_remote_state.infra.outputs.minio_info,
    data.terraform_remote_state.infra.outputs.vpn_info,
    data.terraform_remote_state.infra.outputs.lb_info,
    data.terraform_remote_state.infra.outputs.k3s_control_1_info,
    data.terraform_remote_state.infra.outputs.k3s_control_2_info,
    data.terraform_remote_state.infra.outputs.k3s_control_3_info,
    data.terraform_remote_state.infra.outputs.k3s_worker_info,
    [{ name = "minio", ip = "10.0.0.6" }],
  )

  internal_ingress = [
    "unraid.plexmox.com",
    "minio.plexmox.com",
    "s3.plexmox.com",
    "prometheus.plexmox.com",
    "alerts.plexmox.com",
    "longhorn.plexmox.com",
    "grafana.plexmox.com",
    "maxscale.plexmox.com",
    "thanos.plexmox.com"
  ]

  upstream_dns =  [
    "https://cloudflare-dns.com/dns-query",
    "https://dns10.quad9.net/dns-query"
  ]

  bootstrap_dns = [
    "9.9.9.10",
    "149.112.112.10",
    "2620:fe::10",
    "2620:fe::fe:10",
  ]

  filter_lists = [
    {
      name = "AdGuard DNS Filter"
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
    },
    {
      name = "AdGuard Default Blocklist",
      url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt"
    }
  ]
}
