module "adguard_1" {
  source = "./adguard"

  adguard_host     = data.terraform_remote_state.infra.outputs.adguard_info[0].ip
  adguard_user     = var.adguard_user
  adguard_password = var.adguard_password

  vms                      = local.vm_info
  internal_ingress_targets = local.internal_ingress
  custom_rewrites          = local.custom_rewrites
  upstream_dns             = local.upstream_dns
  bootstrap_dns            = local.bootstrap_dns
  filter_lists             = local.filter_lists
  filter_rules             = local.filter_rules

  dhcp_enabled       = true
  dhcp_interface     = "eth0"
  dhcp_ipv4_settings = local.dhcp_ipv4_settings
  dhcp_static_leases = local.dhcp_static_leases
}

module "adguard_2" {
  source = "./adguard"

  adguard_host     = data.terraform_remote_state.infra.outputs.adguard_info[1].ip
  adguard_user     = var.adguard_user
  adguard_password = var.adguard_password

  vms                      = local.vm_info
  internal_ingress_targets = local.internal_ingress
  custom_rewrites          = local.custom_rewrites
  upstream_dns             = local.upstream_dns
  bootstrap_dns            = local.bootstrap_dns
  filter_lists             = local.filter_lists
  filter_rules             = local.filter_rules

  dhcp_enabled       = false
  dhcp_interface     = "eth0"
  dhcp_ipv4_settings = local.dhcp_ipv4_settings
  dhcp_static_leases = local.dhcp_static_leases
}
