output "access_key_id" {
  value     = minio_iam_user.user.id
  sensitive = true
}

output "secret_access_key" {
  value     = minio_iam_user.user.secret
  sensitive = true
}
