resource "pihole_dns_record" "dns" {
  for_each = {
    for value in local.pihole_dns : value.name => value
  }

  domain = each.value.name
  ip     = each.value.value
}

resource "pihole_dns_record" "internal_ingress" {
  for_each = toset(local.internal_ingress)

  domain = each.value
  ip     = "10.0.0.27"
}
