output "loki_access_key_id" {
  value     = module.loki.access_key_id
  sensitive = true
}
output "loki_secret_access_key" {
  value     = module.loki.secret_access_key
  sensitive = true
}

output "dragonfly_access_key_id" {
  value     = module.dragonfly.access_key_id
  sensitive = true
}
output "dragonfly_secret_access_key" {
  value     = module.dragonfly.secret_access_key
  sensitive = true
}

# output "thanos_access_key_id" {
#   value     = module.thanos.access_key_id
#   sensitive = true
# }
# output "thanos_secret_access_key" {
#   value     = module.thanos.secret_access_key
#   sensitive = true
# }

output "tempo_access_key_id" {
  value     = module.tempo.access_key_id
  sensitive = true
}
output "tempo_secret_access_key" {
  value     = module.tempo.secret_access_key
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
