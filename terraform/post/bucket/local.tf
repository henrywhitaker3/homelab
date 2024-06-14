locals {
  roots = [for b in var.buckets :
    "arn:aws:s3:::${b}"
  ]
  recs = [for b in var.buckets :
    "arn:aws:s3:::${b}/*"
  ]
  resources = concat(local.roots, local.recs)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ${jsonencode(var.permissions)},
      "Resource": ${jsonencode(local.resources)}
    }
  ]
}
EOF
}
