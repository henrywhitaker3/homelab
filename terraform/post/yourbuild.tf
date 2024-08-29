module "yourbuild" {
  source = "./bucket"

  name    = "yourbuild"
  buckets = ["yourbuild"]

  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
