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
output "pyroscope_access_key_id" {
  value     = module.pyroscope.access_key_id
  sensitive = true
}
output "pyroscope_secret_access_key" {
  value     = module.pyroscope.secret_access_key
  sensitive = true
}
output "mariadb_access_key_id" {
  value     = module.mariadb.access_key_id
  sensitive = true
}
output "mariadb_secret_access_key" {
  value     = module.mariadb.secret_access_key
  sensitive = true
}
output "henry_access_key_id" {
  value     = minio_iam_service_account.henry.access_key
  sensitive = true
}
output "henry_secret_access_key" {
  value     = minio_iam_service_account.henry.secret_key
  sensitive = true
}
