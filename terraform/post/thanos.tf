module "thanos" {
  source = "./bucket"

  name      = "thanos"
  buckets   = ["thanos"]
  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
