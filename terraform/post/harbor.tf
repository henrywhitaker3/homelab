module "harbor" {
  source = "./bucket"

  name    = "harbor"
  buckets = ["harbor"]

  acl = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
