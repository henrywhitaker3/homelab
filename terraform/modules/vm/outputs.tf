output "this" {
  value = [
    for key, val in proxmox_vm_qemu.vm : {
      name  = val.name
      ip    = var.ips[key]
      cores = val.cpu[0].cores
    }
  ]
}
