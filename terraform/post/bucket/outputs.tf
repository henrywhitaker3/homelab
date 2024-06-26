output "access_key_id" {
  value     = minio_iam_service_account.service_account.access_key
  sensitive = true
}

output "secret_access_key" {
  value     = minio_iam_service_account.service_account.secret_key
  sensitive = true
}
