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

output "longhorn_access_key_id" {
  value     = module.longhorn.access_key_id
  sensitive = true
}

output "longhorn_secret_access_key" {
  value     = module.longhorn.secret_access_key
  sensitive = true
}
