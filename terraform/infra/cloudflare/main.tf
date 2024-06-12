data "cloudflare_zone" "zone" {
  name = var.zone
}

resource "cloudflare_record" "records" {
  for_each = {
    for value in var.records : value.name => value
  }

  zone_id = data.cloudflare_zone.zone.zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type
  proxied = each.value.proxied
}

locals {
  geo_block_expression = join(" ", [for name in var.geo_block : format("%q", name)])
}

resource "cloudflare_ruleset" "geo_block" {
  zone_id     = data.cloudflare_zone.zone.zone_id
  name        = "Geo block"
  description = "Blocks access from specified coutries"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action     = "block"
    expression = "(ip.geoip.country in {${local.geo_block_expression}})"
  }
}
