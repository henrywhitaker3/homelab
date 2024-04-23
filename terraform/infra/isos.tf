resource "proxmox_storage_iso" "talos" {
  count = 3

  url                = "https://factory.talos.dev/image/4ea1b20f73a7b3eac7faac4a02193470a85d0e2c441af474ddfd2de2e8da4dc7/v1.7.0/metal-amd64.iso"
  checksum           = "493190e8f19c2614b645d30abc589b9ecc555b2f6876c11f9840a03c275469d6"
  checksum_algorithm = "sha256"
  filename           = "talos.iso"
  storage            = "local"
  pve_node           = "proxmox-0${count.index + 1}"
}
