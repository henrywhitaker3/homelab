variable "netbird_networks" {
  type = map(object({
    description = optional(string, null)
    data        = optional(bool, false)
  }))
  default = {}
}

resource "netbird_network" "this" {
  for_each = {
    for key, value in var.netbird_networks : key => value if !value.data
  }

  name        = each.key
  description = each.value.description
}

data "netbird_network" "this" {
  for_each = {
    for key, value in var.netbird_networks : key => value if value.data
  }
  name = each.key
}

variable "netbird_setup_keys" {
  type = map(object({
    expiry_seconds = optional(number, 0)
    revoked        = optional(bool, false)
    type           = optional(string, "one-off")
    usage_limit    = optional(number, 1)
    auto_groups    = optional(list(string), null)
  }))
  default = {}
}

locals {
  netbird_vms = {
    for vm in flatten(concat(
      data.terraform_remote_state.infra.outputs.adguard_info,
      data.terraform_remote_state.infra.outputs.minio_info,
      data.terraform_remote_state.infra.outputs.lb_info,
      data.terraform_remote_state.infra.outputs.k3s_control_info,
      data.terraform_remote_state.infra.outputs.k3s_dedi_info,
    )) : vm.name => vm
  }

  netbird_peer_vms = {
    for vm in flatten(concat(
      data.terraform_remote_state.infra.outputs.adguard_info,
      data.terraform_remote_state.infra.outputs.minio_info,
      data.terraform_remote_state.infra.outputs.lb_info,
      data.terraform_remote_state.infra.outputs.k3s_control_info,
      data.terraform_remote_state.infra.outputs.k3s_dedi_info,
    )) : vm.name => vm
  }

  netbird_setup_keys = merge(
    {
      for key, value in var.netbird_setup_keys : key => value
    },
    {
      for key, value in local.netbird_vms : key => {
        expiry_seconds = 0
        revoked        = false
        type           = "one-off"
        usage_limit    = 1
        auto_groups    = ["homelab"]
      }
    }
  )

  netbird_peers = merge(
    {
      for key, value in var.netbird_peers : key => value
    },
    {
      for key, value in local.netbird_peer_vms : key => value
    },
  )
}

resource "netbird_setup_key" "this" {
  for_each = local.netbird_setup_keys

  name           = each.key
  expiry_seconds = each.value.expiry_seconds
  revoked        = each.value.revoked
  type           = each.value.type
  usage_limit    = each.value.usage_limit
  auto_groups = [
    for group in each.value.auto_groups : try(
      netbird_group.this[group].id,
      data.netbird_group.this[group].id,
    )
  ]
}

output "netbird_setup_keys" {
  value = {
    for key, value in netbird_setup_key.this : key => value.key
  }
  sensitive = true
}

variable "netbird_peers" {
  type    = map(object({}))
  default = {}
}

data "netbird_peer" "this" {
  for_each = local.netbird_peers

  name = each.key
}

variable "netbird_groups" {
  type = map(object({
    peers = optional(list(string), [])
    data  = optional(bool, false)
  }))
  default = {}
}

resource "netbird_group" "this" {
  for_each = {
    for key, value in var.netbird_groups : key => value if !value.data
  }

  name = each.key
  peers = sort([
    for peer in each.value.peers : data.netbird_peer.this[peer].id
  ])
}

data "netbird_group" "this" {
  for_each = {
    for key, value in var.netbird_groups : key => value if value.data
  }
  name = each.key

}

variable "netbird_routers" {
  type = map(object({
    network     = string
    masquerade  = optional(bool, true)
    enabled     = optional(bool, true)
    metric      = optional(number, null)
    peer_groups = optional(list(string), [])
  }))
  default = {}
}

resource "netbird_network_router" "this" {
  for_each = var.netbird_routers

  enabled    = each.value.enabled
  masquerade = each.value.masquerade
  metric     = each.value.metric
  network_id = try(
    netbird_network.this[each.value.network].id,
    data.netbird_network.this[each.value.network].id,
  )
  peer_groups = [
    for peer in each.value.peer_groups : try(
      netbird_group.this[peer].id,
      data.netbird_group.this[peer].id,
    )
  ]
}

variable "netbird_resources" {
  type = map(object({
    name        = optional(string, null)
    data        = optional(bool, false)
    description = optional(string, null)
    network     = string
    address     = optional(string, null)
    groups      = optional(list(string), null)
    enabled     = optional(bool, true)
  }))
  default = {}
}

resource "netbird_network_resource" "this" {
  for_each = {
    for key, value in var.netbird_resources : key => value if !value.data
  }

  name        = each.key
  description = each.value.description
  network_id = try(
    netbird_network.this[each.value.network].id,
    data.netbird_network.this[each.value.network].id,
  )
  address = each.value.address
  groups = [
    for group in each.value.groups : try(
      netbird_group.this[group].id,
      data.netbird_group.this[group].id,
    )
  ]
  enabled = each.value.enabled
}

data "netbird_network_resource" "this" {
  for_each = {
    for key, value in var.netbird_resources : key => value if value.data
  }
  name = try(
    each.value.name,
    each.key,
  )
  network_id = try(
    netbird_network.this[each.value.network].id,
    data.netbird_network.this[each.value.network].id,
  )
}

variable "netbird_policies" {
  type = map(object({
    description = optional(string, null)
    enabled     = optional(bool, true)
    rule = object({
      description   = optional(string, null)
      action        = string
      bidirectional = optional(bool, false)
      protocol      = string
      ports         = optional(list(number), null)
      port_ranges = optional(list(object({
        start = number
        end   = number
      })), null)
      sources              = optional(list(string), null)
      destinations         = optional(list(string), null)
      source_resource      = optional(string, null)
      destination_resource = optional(string, null)
    })
  }))
  default = {}
}

resource "netbird_policy" "this" {
  for_each = var.netbird_policies

  name        = each.key
  description = each.value.description
  enabled     = each.value.enabled

  rule {
    name          = each.key
    description   = each.value.rule.description
    action        = each.value.rule.action
    bidirectional = each.value.rule.bidirectional
    protocol      = each.value.rule.protocol
    ports         = each.value.rule.ports
    port_ranges   = each.value.rule.port_ranges
    sources = each.value.rule.sources == null ? null : [
      for source in each.value.rule.sources : try(
        netbird_group.this[source].id,
        data.netbird_group.this[source].id,
      )
    ]
    destinations = each.value.rule.destinations == null ? null : [
      for dest in each.value.rule.destinations : try(
        netbird_group.this[dest].id,
        data.netbird_group.this[dest].id,
      )
    ]
    source_resource = each.value.rule.source_resource == null ? null : {
      id = try(
        netbird_network_resource.this[each.value.rule.source_resource].id,
        data.netbird_network_resource.this[each.value.rule.source_resource].id,
      )
      type = ""
    }
    destination_resource = each.value.rule.destination_resource == null ? null : {
      id = try(
        netbird_network_resource.this[each.value.rule.destination_resource].id,
        data.netbird_network_resource.this[each.value.rule.destination_resource].id,
        each.value.rule.destination_resource,
      )
      type = ""
    }
  }
}

variable "netbird_nameservers" {

  type = map(object({
    description            = optional(string, null)
    groups                 = list(string)
    search_domains_enabled = optional(bool, false)
    domains                = optional(list(string), null)
    nameservers = map(object({
      ip   = string
      type = optional(string, "udp")
      port = optional(number, 53)
    }))
  }))
  default = {}
}

resource "netbird_nameserver_group" "this" {
  for_each = var.netbird_nameservers

  name        = each.key
  description = each.value.description
  groups = [
    for group in each.value.groups : try(
      netbird_group.this[group].id,
      data.netbird_group.this[group].id,
    )
  ]
  domains                = each.value.domains
  search_domains_enabled = each.value.search_domains_enabled
  nameservers = [
    for key, value in each.value.nameservers : {
      ip      = value.ip
      ns_type = value.type
      port    = value.port
    }
  ]
}
