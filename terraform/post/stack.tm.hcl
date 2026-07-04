stack {
  name        = "post"
  description = "post"
  id          = "d3607ecd-1397-45a4-a97e-e0a210c58174"
  after       = ["../infra"]
}

input "adguard_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.vms.value.adguard
}

input "lb_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.vms.value.lb
}

input "k3s_control_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.vms.value.k3s_control
}

input "k3s_dedi_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.vms.value.k3s_dedi
}

input "dev_info" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.vms.value.dev
}

input "digitalocean_vms" {
  backend       = "default"
  from_stack_id = "26657b10-825a-416f-b0f4-16d821c773e8"
  value         = outputs.digitalocean_vms.value
}
