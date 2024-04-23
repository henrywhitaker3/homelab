locals {
  proxmox_host = "10.0.0.150"

  ubuntu_22_04 = "ubuntu-22.04-cloud"
  ubuntu_24_04 = "ubuntu-24.04-cloud"

  # renovate: datasource=github-releases depName=siderolabs/talos
  talos_version = "v1.7.0"
}
