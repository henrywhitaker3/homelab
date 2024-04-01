locals {
  pihole_dns = [
    {
      name  = "adguard-1.lab"
      value = data.terraform_remote_state.infra.outputs.adguard_1_ip
    },
    {
      name  = "adguard-2.lab"
      value = data.terraform_remote_state.infra.outputs.adguard_2_ip
    },
    {
      name  = "lb-1.lab"
      value = data.terraform_remote_state.infra.outputs.lb_1_ip
    },
    {
      name  = "lb-2.lab"
      value = data.terraform_remote_state.infra.outputs.lb_2_ip
    },
    {
      name  = "vpn-1.lab"
      value = data.terraform_remote_state.infra.outputs.vpn_1_ip
    },
    {
      name  = "vpn-2.lab"
      value = data.terraform_remote_state.infra.outputs.vpn_2_ip
    },
    {
      name  = "k3s-control-1.lab"
      value = data.terraform_remote_state.infra.outputs.k3s_control_1_ip
    },
    {
      name  = "k3s-control-2.lab"
      value = data.terraform_remote_state.infra.outputs.k3s_control_2_ip
    },
    {
      name  = "k3s-control-3.lab"
      value = data.terraform_remote_state.infra.outputs.k3s_control_3_ip
    },
    {
      name  = "k3s-worker-1.lab"
      value = data.terraform_remote_state.infra.outputs.k3s_worker_1_ip
    },
    {
      name  = "k3s-worker-2.lab"
      value = data.terraform_remote_state.infra.outputs.k3s_worker_2_ip
    },
    {
      name  = "minio-1.lab"
      value = data.terraform_remote_state.infra.outputs.minio_1_ip
    },
    {
      name  = "minio-2.lab"
      value = data.terraform_remote_state.infra.outputs.minio_2_ip
    },
    {
      name  = "compactor.lab"
      value = data.terraform_remote_state.infra.outputs.thanos_compactor_ip
    },
    {
      name  = "minio.lab"
      value = "10.0.0.6"
    },
  ]

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
