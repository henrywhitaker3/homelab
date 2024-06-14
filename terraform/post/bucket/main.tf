resource "minio_s3_bucket" "bucket" {
  for_each = toset(var.buckets)

  bucket = each.value
  acl    = var.acl
}

resource "minio_iam_user" "user" {
  name = var.name
}

resource "minio_iam_policy" "policy" {
  name       = var.name
  policy     = local.policy
  depends_on = [minio_iam_user.user, minio_s3_bucket.bucket]
}

resource "minio_iam_user_policy_attachment" "policy_attachment" {
  user_name   = minio_iam_user.user.id
  policy_name = minio_iam_policy.policy.id
}

resource "minio_ilm_policy" "lifecycle" {
  for_each = var.retention != 0 ? toset(var.buckets) : []

  bucket = minio_s3_bucket.bucket[each.value].id

  rule {
    id         = "expire-${var.retention}d"
    expiration = "${var.retention}d"
  }
}

resource "minio_iam_service_account" "service_account" {
  target_user = minio_iam_user.user.name
  policy      = local.policy

  depends_on = [minio_iam_policy.policy]
}
