variable "peers" {
  type = map(object({
    mesh_ip = string
    # The ip peers can connect to this peer with
    peer_ip     = optional(string, null)
    public_peer = optional(bool, false)
    dns         = optional(list(string), null)
    listen_port = optional(number, 51820)
    pre_up      = optional(list(string), null)
    pre_down    = optional(list(string), null)
    post_up     = optional(list(string), null)
    post_down   = optional(list(string), null)
    peers = optional(map(object({
      allowed_ips          = optional(list(string), [])
      persistent_keepalive = optional(number, null)
      endpoint             = optional(bool, false)
    })), {})
    sops_config_file = optional(string, null)
  }))
  default = {}
}
