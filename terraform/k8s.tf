resource "proxmox_vm_qemu" "k8s-admin" {
  count = 1

  name = "k8s-admin"

  target_node = var.proxmox_node_1

  clone = var.ubuntu_8G

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
  ipconfig0 = "ip=10.0.0.20/24,gw=10.0.0.1"
}

resource "proxmox_vm_qemu" "k8s-nodes" {
  count = 2

  name = "k8s-0${count.index + 1}"

  target_node = var.proxmox_node_1

  clone = var.ubuntu_100G

  agent   = 1
  os_type = "cloud-init"
  cores   = 2
  sockets = "1"
  cpu     = "host"
  memory  = 4096

  lifecycle {
    ignore_changes = [
      network,
      ciuser,
      sshkeys,
      disk
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=10.0.0.${20 + (count.index + 1)}/24,gw=10.0.0.1"
}
