module "crunchy" {
  source = "./bucket"

  name    = "crunchy"
  buckets = ["crunchy"]

  acl = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
