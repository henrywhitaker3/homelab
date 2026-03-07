variable "oidc_clients" {
  type = map(object({
    name                      = string
    callback_urls             = optional(list(string), [])
    public                    = optional(bool, false)
    pkce_enabled              = optional(bool, false)
    requires_reauthentication = optional(bool, false)
    url                       = optional(string, null)
    allowed_groups            = optional(list(string), null)
  }))
  default = {}
}

resource "pocketid_client" "this" {
  for_each = var.oidc_clients

  name                      = each.value.name
  callback_urls             = each.value.callback_urls
  is_public                 = each.value.public
  pkce_enabled              = each.value.pkce_enabled
  requires_reauthentication = each.value.requires_reauthentication
  launch_url                = each.value.url
  allowed_user_groups       = each.value.allowed_groups
}

output "oidc_clients" {
  value = {
    for key, val in var.oidc_clients : key => {
      client_secret = pocketid_client.this[key].client_secret
    }
  }
  sensitive = true
}
