module "tempo" {
  source = "./bucket"

  name    = "tempo"
  buckets = ["tempo"]

  acl = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
