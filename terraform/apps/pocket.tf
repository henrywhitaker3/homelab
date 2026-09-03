variable "oidc_clients" {
  type = map(object({
    name                      = string
    callback_urls             = optional(list(string), [])
    public                    = optional(bool, false)
    pkce_enabled              = optional(bool, false)
    requires_reauthentication = optional(bool, false)
    url                       = optional(string, null)
    allowed_groups            = optional(list(string), ["admin"])
  }))
  default = {}
}

locals {
  pocketid_groups = toset(concat([
    for key, val in var.oidc_clients : val.allowed_groups
  ]...))
}

data "pocketid_group" "this" {
  for_each = local.pocketid_groups

  name = each.value
}

resource "pocketid_client" "this" {
  for_each = var.oidc_clients

  name                      = each.value.name
  callback_urls             = each.value.callback_urls
  is_public                 = each.value.public
  pkce_enabled              = each.value.pkce_enabled
  requires_reauthentication = each.value.requires_reauthentication
  launch_url                = each.value.url
  allowed_user_groups = [
    for val in each.value.allowed_groups : data.pocketid_group.this[val].id
  ]
}

output "oidc_clients" {
  value = {
    for key, val in var.oidc_clients : key => {
      client_id     = pocketid_client.this[key].id
      client_secret = pocketid_client.this[key].client_secret
    }
  }
  sensitive = true
}
