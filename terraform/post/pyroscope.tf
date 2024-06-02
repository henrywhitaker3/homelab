module "pyroscope" {
  source = "./bucket"

  name    = "pyroscope"
  buckets = ["pyroscope"]

  acl = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
