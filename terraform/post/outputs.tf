output "dragonfly_access_key_id" {
  value     = module.dragonfly.access_key_id
  sensitive = true
}

output "dragonfly_secret_access_key" {
  value     = module.dragonfly.secret_access_key
  sensitive = true
}

output "loki_access_key_id" {
  value     = module.loki.access_key_id
  sensitive = true
}

output "loki_secret_access_key" {
  value     = module.loki.secret_access_key
  sensitive = true
}

output "thanos_access_key_id" {
  value     = module.thanos.access_key_id
  sensitive = true
}
output "thanos_secret_access_key" {
  value     = module.thanos.secret_access_key
  sensitive = true
}
