resource "proxmox_vm_qemu" "test_server" {
  count = 1

  name = "test-vm"

  target_node = var.proxmox_node_1

  clone = var.ubuntu_25G

  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 2048

  # Cloud Init Settings
  ipconfig0 = "ip=10.0.0.8/24,gw=10.0.0.1"
}
