data "cloudflare_zone" "zone" {
  filter = {
    name = var.zone
  }
}


locals {
  geo_block_expression = join(" ", [for name in var.geo_block : format("%q", name)])
}

resource "cloudflare_ruleset" "geo_block" {
  zone_id     = data.cloudflare_zone.zone.id
  name        = "Geo block"
  description = "Blocks access from specified coutries"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action     = "block"
      expression = "(ip.geoip.country in {${local.geo_block_expression}})"
    }
  ]
}

resource "cloudflare_dns_record" "records" {
  for_each = var.records

  zone_id = data.cloudflare_zone.zone.id
  name    = each.value.name
  content = each.value.value
  type    = each.value.type
  proxied = each.value.proxied
  ttl     = 1
}

moved {
  from = cloudflare_record.records
  to   = cloudflare_dns_record.records
}
