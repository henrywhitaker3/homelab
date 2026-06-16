stack {
  name        = "post"
  description = "post"
  id          = "d3607ecd-1397-45a4-a97e-e0a210c58174"
  after       = ["../infra"]
}

input "adguard_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.adguard_info.value
}

input "lb_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.lb_info.value
}

input "k3s_control_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.k3s_control_info.value
}

input "k3s_dedi_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.k3s_dedi_info.value
}

input "digitalocean_vms" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.digitalocean_vms.value
}
