resource "proxmox_storage_iso" "talos" {
  count = 3

  url                = "https://github.com/siderolabs/talos/releases/download/${local.talos_version}/metal-amd64.iso"
  checksum           = "f3eb533962bec805fa68e3856164ce5baacbd60505f5b3590beb853da30d926e"
  checksum_algorithm = "sha256"
  filename           = "talos.iso"
  storage            = "local"
  pve_node           = "proxmox-0${count.index + 1}"
}
