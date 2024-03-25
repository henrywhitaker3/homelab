locals {
  roots = [for b in var.buckets :
    "arn:aws:s3:::${b}"
  ]
  recs = [for b in var.buckets :
    "arn:aws:s3:::${b}/*"
  ]
  resources = concat(local.roots, local.recs)
}
