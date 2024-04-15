output "lb_info" {
  value = module.lb.info
}
output "vpn_info" {
  value = module.vpn.info
}
output "k3s_control_info" {
  value = concat(
    module.k3s-control.info,
    [
      {
        name = "k3s-control-3"
        ip   = "10.0.0.24"
      }
    ]
  )
}
output "k3s_worker_info" {
  value = module.k3s-worker.info
}
output "minio_info" {
  value = module.minio.info
}
output "adguard_info" {
  value = module.adguard.info
}
