locals {
  pihole_dns = [
    {
      name  = "pihole.lab"
      value = data.terraform_remote_state.infra.outputs.pihole_ip
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
  ]

  internal_ingress = [
    "unraid.plexmox.com",
    "minio.plexmox.com",
    "s3.plexmox.com",
    "prometheus.plexmox.com",
    "alerts.plexmox.com",
    "longhorn.plexmox.com"
  ]
}
