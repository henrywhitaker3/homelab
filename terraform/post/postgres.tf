module "postgres" {
  source = "./bucket"

  name      = "postgres"
  buckets   = ["postgres"]
  acl       = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
