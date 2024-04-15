resource "adguard_rewrite" "dns_primary" {
  provider = adguard.adguard-1
  for_each = {
    for value in local.vm_info : "${value.name}.lab" => value
  }

  domain = each.key
  answer = each.value.ip
}

resource "adguard_rewrite" "dns_secondary" {
  provider = adguard.adguard-2
  for_each = {
    for value in local.vm_info : "${value.name}.lab" => value
  }

  domain = each.key
  answer = each.value.ip
}

resource "adguard_rewrite" "internal_ingress_primary" {
  provider = adguard.adguard-1
  for_each = toset(local.internal_ingress)

  domain = each.value
  answer = "10.0.0.27"
}

resource "adguard_rewrite" "internal_ingress_secondary" {
  provider = adguard.adguard-2
  for_each = toset(local.internal_ingress)

  domain = each.value
  answer = "10.0.0.27"
}
