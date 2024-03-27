output "pihole_ip" {
  value = module.pihole.ip
}
output "lb_1_ip" {
  value = module.lb-1.ip
}
output "lb_2_ip" {
  value = module.lb-2.ip
}
output "vpn_1_ip" {
  value = module.vpn-1.ip
}
output "vpn_2_ip" {
  value = module.vpn-2.ip
}
output "k3s_control_1_ip" {
  value = module.k3s-control-1.ip
}
output "k3s_control_2_ip" {
  value = module.k3s-control-2.ip
}
output "k3s_control_3_ip" {
  value = "10.0.0.24"
}
output "k3s_worker_1_ip" {
  value = module.k3s-worker-1.ip
}
output "k3s_worker_2_ip" {
  value = module.k3s-worker-2.ip
}
output "minio_1_ip" {
  value = module.minio-1.ip
}
output "minio_2_ip" {
  value = module.minio-2.ip
}
