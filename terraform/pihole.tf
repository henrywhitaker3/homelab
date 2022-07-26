resource "proxmox_vm_qemu" "pihole" {
  count = 1

  name = "pihole"

  target_node = var.proxmox_default_node

  clone = var.ubuntu_8G

  agent             = 1
  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 2048

  lifecycle {
    ignore_changes = [
      network,
      ciuser,
      sshkeys,
      disk
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=10.0.0.2/24,gw=10.0.0.1"
  nameserver = "1.1.1.1 8.8.8.8"
}
