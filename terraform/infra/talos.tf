

locals {
  talos_images = {
    nocloud_amd64 = {
      platform = "nocloud"
      arch     = "amd64"
      # renovate: datasource=github-releases depName=siderolabs/talos
      version = "v1.8.3"
    }
  }

  talos_clusters = {
    # mango = {
    #   image_key = "nocloud_amd64"
    #   nodes = {
    #     control_1 = {
    #       name        = "control-1"
    #       id = 200
    #       node        = 1
    #       cores       = 2
    #       memory      = 2048
    #       disk_size   = 30
    #       mac_address = "18:2f:a3:3e:dc:7a"
    #     }
    #     control_2 = {
    #       name        = "control-2"
    #       id = 201
    #       node        = 2
    #       cores       = 2
    #       memory      = 2048
    #       disk_size   = 30
    #       mac_address = "18:88:df:e6:c2:99"
    #     }
    #     control_3 = {
    #       name        = "control-3"
    #       id = 202
    #       node        = 3
    #       cores       = 2
    #       memory      = 2048
    #       disk_size   = 30
    #       mac_address = "18:e7:3e:fa:e1:f9"
    #     }
    #   }
    # }
  }
}

data "http" "talos_images" {
  for_each = local.talos_images

  url          = "https://factory.talos.dev/schematics"
  method       = "POST"
  request_body = lookup(each.value, "schematic", file("./talos/schematic.yaml"))
}

resource "proxmox_storage_iso" "talos" {
  for_each = local.computed_isos

  url      = "https://factory.talos.dev/image/${each.value.schematic_id}/${each.value.version}/${each.value.platform}-${each.value.arch}.iso"
  filename = "talos-${each.value.schematic_id}-${each.value.version}.iso"
  storage  = lookup(each.value, "storage", "local")
  pve_node = each.value.node
}

resource "proxmox_vm_qemu" "talos" {
  for_each = local.computed_talos_vms

  name     = each.value.name
  vmid = each.value.id

  target_node = "proxmox-0${each.value.node}"

  agent    = 0
  cores    = each.value.cores
  sockets  = "1"
  cpu      = "host"
  memory   = each.value.memory
  onboot   = true
  scsihw   = "virtio-scsi-pci"
  qemu_os  = "l26"
  vm_state = "running"

  disks {
    ide {
      ide2 {
        cdrom {
          iso = each.value.iso
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = lookup(each.value, "storage", "local-lvm")
          size    = replace(each.value.disk_size, "G", "")
          format  = "raw"
        }
      }
    }
  }

  network {
    model   = "virtio"
    bridge  = lookup(each.value, "network_bridge", "vmbr0")
    macaddr = each.value.mac_address
  }

  tags = join(";", concat(lookup(each.value, "tags", []), ["talos"]))
}

locals {
  computed_images = {
    for key, value in local.talos_images : key => {
      platform     = value.platform
      arch         = value.arch
      version      = value.version
      schematic_id = jsondecode(data.http.talos_images[key].response_body)["id"]
    }
  }

  computed_isos = merge(
    {
      for key, value in local.computed_images : format("%s_01", key) => merge(
        value,
        {
          node = "proxmox-01"
        }
      )
    },
    {
      for key, value in local.computed_images : format("%s_02", key) => merge(
        value,
        {
          node = "proxmox-02"
        }
      )
    },
    {
      for key, value in local.computed_images : format("%s_03", key) => merge(
        value,
        {
          node = "proxmox-03"
        }
      )
    },
  )

  computed_talos_vms = {
    for vm in flatten([
      for key, value in local.talos_clusters : [
        for n_key, n_value in value.nodes : {
          name        = format("%s-%s", lookup(value, "name", key), n_value.name)
          id = n_value.id
          node        = n_value.node
          cores       = n_value.cores
          memory      = n_value.memory
          disk_size   = n_value.disk_size
          mac_address = n_value.mac_address
          iso         = format("%s:iso/%s", lookup(value, "iso_storage", "local"), proxmox_storage_iso.talos[format("%s_0%d", value.image_key, n_value.node)].filename)
        }
      ]
    ]) : vm.name => vm
  }
}
