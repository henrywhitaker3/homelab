module "outline" {
  source = "./bucket"

  name      = "outline"
  buckets   = ["outline"]
  acl       = "public-read"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
