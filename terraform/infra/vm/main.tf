data "external" "node_index" {
  count   = var.instances
  program = ["bash", "${path.module}/node_index.sh", length(var.nodes), count.index + 1]
}

resource "proxmox_vm_qemu" "vm" {
  count = var.instances

  name = local.info[count.index].name

  target_node = "proxmox-0${var.nodes[data.external.node_index[count.index].result.index]}"

  clone = var.iso == "" ? "${var.image}-node-${var.nodes[data.external.node_index[count.index].result.index]}" : null
  # iso   = var.iso == "" ? null : var.iso

  agent           = 1
  os_type         = "cloud-init"
  memory          = var.memory
  onboot          = true
  scsihw          = "virtio-scsi-pci"
  qemu_os         = "other"
  additional_wait = 0
  clone_wait      = 0
  vm_state        = "running"

  cpu {
    cores   = var.cores
    type    = "host"
    sockets = "1"
  }

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = replace(var.disk_size, "G", "")
          storage = var.disk_storage
          format  = "raw"
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
  ipconfig0  = "ip=${local.info[count.index].ip}/${local.cidrBlock},gw=${var.gateway}"
  nameserver = var.nameserver
  ciuser     = var.user
  sshkeys    = join("\n", var.ssh_keys)
}
