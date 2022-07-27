resource "proxmox_vm_qemu" "alma" {
  count = 1

  name = "alma"

  target_node = var.proxmox_default_node

  clone = var.alma_10G

  agent   = 1
  os_type = "cloud-init"
  cores   = 1
  sockets = "1"
  cpu     = "host"
  memory  = 512

  lifecycle {
    ignore_changes = [
      network,
      ciuser,
      sshkeys,
      disk
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=10.0.0.15/24,gw=10.0.0.1"
}
