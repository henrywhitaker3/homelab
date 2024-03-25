locals {
  proxmox_host = "10.0.0.150"

  ubuntu_22_04 = "ubuntu-22.04-cloud"

  internal_dns = [
    "unraid.plexmox.com",
    "minio.plexmox.com",
    "s3.plexmox.com",
    "prometheus.plexmox.com",
    "alerts.plexmox.com",
    "longhorn.plexmox.com"
  ]
}
