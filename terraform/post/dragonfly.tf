module "dragonfly" {
  source = "./bucket"

  name    = "dragonfly"
  buckets = ["dragonfly"]

  retention = 3
  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
