module "loki" {
  source = "./bucket"

  name    = "loki"
  buckets = ["loki-chunks"]

  retention = 60
  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
