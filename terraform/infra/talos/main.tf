resource "proxmox_vm_qemu" "vm" {
  name = var.name

  target_node = "proxmox-0${var.node}"

  iso = "${var.iso_storage}:iso/${var.iso}"

  agent    = 0
  cores    = var.cores
  sockets  = "1"
  cpu      = "host"
  memory   = var.memory
  onboot   = true
  scsihw   = "virtio-scsi-pci"
  qemu_os  = "l26"
  vm_state = "running"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = replace(var.disk_size, "G", "")
          storage = var.storage
          format  = "raw"
        }
      }
    }
  }

  network {
    model   = "virtio"
    bridge  = var.network_bridge
    macaddr = var.mac_address
  }

  tags = join(";", var.tags)

}
