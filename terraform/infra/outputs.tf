output "lb_info" {
  value = module.lb.info
}
output "k3s_control_info" {
  value = module.k3s-control.info
}

output "k3s_vpn_info" {
  value = module.k3s-vpn.info
}

output "k3s_dedi_info" {
  value = [
    {
      name = "k3s-dedi-1"
      ip   = "10.0.0.24"
    }
  ]
}
output "minio_info" {
  value = module.minio.info
}
output "adguard_info" {
  value = module.adguard.info
}
