module "longhorn" {
  source = "./bucket"

  name      = "longhorn"
  buckets   = ["longhorn"]
  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
