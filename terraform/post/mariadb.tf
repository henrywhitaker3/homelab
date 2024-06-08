module "mariadb" {
  source = "./bucket"

  name    = "mariadb"
  buckets = ["mariadb"]

  acl = "private"
  permissions = [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ]
}
