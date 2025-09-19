resource "wireguard_asymmetric_key" "this" {
  for_each = var.peers
}

resource "wireguard_preshared_key" "this" {
  for_each = local.peer_connections
}

data "wireguard_config_document" "this" {
  for_each = var.peers

  addresses   = [format("%s/24", each.value.mesh_ip)]
  private_key = wireguard_asymmetric_key.this[each.key].private_key
  listen_port = each.value.listen_port
  dns         = each.value.dns
  pre_up      = each.value.pre_up
  pre_down    = each.value.pre_down
  post_up     = each.value.post_up
  post_down   = each.value.post_down

  dynamic "peer" {
    for_each = merge(
      {
        for key, value in var.peers : key => value if each.value.public_peer && each.key != key
      },
      {
        for key, value in each.value.peers : key => value
      },
    )
    content {
      public_key  = wireguard_asymmetric_key.this[peer.key].public_key
      description = peer.key
      endpoint = lookup(peer.value, "endpoint", lookup(peer.value, "public_peer", false)) ? format(
        "%s:%d",
        var.peers[peer.key].peer_ip,
        var.peers[peer.key].listen_port
      ) : null
      # allowed_ips = lookup(peer.value, "allowed_ips", null)
      allowed_ips = flatten([
        [format("%s/32", var.peers[peer.key].mesh_ip)],
        lookup(peer.value, "allowed_ips", [])
      ])
      preshared_key = wireguard_preshared_key.this[
        format(
          "%s_%s",
          sort([each.key, peer.key])[0],
          sort([each.key, peer.key])[1]
        )
      ].key
      persistent_keepalive = lookup(peer.value, "persistent_keepalive", null)
    }
  }
}

resource "local_sensitive_file" "configs" {
  for_each = {
    for key, value in var.peers : key => value if value.sops_config_file != null
  }
  filename = each.value.sops_config_file
  content = yamlencode({
    wireguard_config = data.wireguard_config_document.this[each.key].conf
  })

  provisioner "local-exec" {
    command = format("sops encrypt --in-place %s", each.value.sops_config_file)
  }
}

locals {
  peer_connections = {
    for item in flatten([
      for key, value in var.peers : concat([
        for p_key, p_value in value.peers : {
          key = format("%s_%s", sort([key, p_key])[0], sort([key, p_key])[1])
        }
      ])
    ]) : item.key => item...
  }
}

output "configs" {
  value = {
    for key, value in data.wireguard_config_document.this : key => value.conf
  }
  sensitive = true
}
