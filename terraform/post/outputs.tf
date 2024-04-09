output "loki_access_key_id" {
  value     = module.loki.access_key_id
  sensitive = true
}
output "loki_secret_access_key" {
  value     = module.loki.secret_access_key
  sensitive = true
}

output "outline_access_key_id" {
  value     = module.loki.access_key_id
  sensitive = true
}
output "outline_secret_access_key" {
  value     = module.outline.secret_access_key
  sensitive = true
}
