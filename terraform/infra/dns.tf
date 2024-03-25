resource "pihole_dns_record" "dns" {
  for_each = toset(local.internal_dns)

  domain = each.value
  ip = "10.0.0.27"
}
