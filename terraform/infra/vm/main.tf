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
  onboot = true
  scsihw = "virtio-scsi-pci"
  qemu_os = "other"
  additional_wait = 0
  clone_wait = 0
  vm_state = "running"
  cloudinit_cdrom_storage = "local-lvm"

  disks {
    scsi {
        scsi0 {
            disk {
                size = replace(var.disk_size, "G", "")
                storage = var.disk_storage
                format = "raw"
            }
        }
    }
  }

  tags = join(";", var.tags)

  lifecycle {
    ignore_changes = [
      network,
      ciuser,
      sshkeys,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=${local.ipPrefix}.${local.ipBit + count.index}/${local.cidrBlock},gw=${var.gateway}"
  nameserver = var.nameserver
}
