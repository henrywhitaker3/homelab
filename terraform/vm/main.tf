resource "proxmox_vm_qemu" "vm" {
  count = var.instances

  name = "${var.name}${var.instances > 1 ? "-${count.index + 1}" : ""}"

  target_node = "proxmox-0${var.node}"

  clone = "${var.image}-node-${var.node}"

  agent   = 1
  os_type = "cloud-init"
  cores   = var.cores
  sockets = "1"
  cpu     = "host"
  memory  = var.memory

  lifecycle {
    ignore_changes = [
      network,
      ciuser,
      sshkeys,
      disk
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=10.0.0.${var.ip + count.index}/24,gw=10.0.0.1"
  nameserver = var.nameserver
}
