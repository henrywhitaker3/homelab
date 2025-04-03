variable "buckets" {
  type = map(object({
    name      = string
    retention = optional(number, null)
    acl       = optional(string, "private")
    type      = string
  }))
  validation {
    condition = length([
      for key, value in var.buckets : true
      if contains(["private", "public"], value.acl)
    ]) == length(var.buckets)
    error_message = "acl must be one of: private, public"
  }
  validation {
    condition = length([
      for key, value in var.buckets : true
      if contains(["minio", "r2"], value.type)
    ]) == length(var.buckets)
    error_message = "type must be one of: minio, r2"
  }
}

variable "minio_tokens" {
  type = map(object({
    name    = string
    buckets = list(string)
    write   = optional(bool, false)
  }))
  validation {
    condition = length([
      for key, value in var.minio_tokens : true
      if length([
        for b_key, b_value in value.buckets : true
        if contains(keys(var.buckets), b_value)
      ]) == length(value.buckets)
    ]) == length(var.minio_tokens)
    error_message = "buckets must be defined in var.buckets"
  }
}

variable "r2_tokens" {
  type = map(object({
    buckets = list(string)
    write   = optional(bool, false)
  }))
  validation {
    condition = length([
      for key, value in var.r2_tokens : true
      if length([
        for b_key, b_value in value.buckets : true
        if contains(keys(var.buckets), b_value)
      ]) == length(value.buckets)
    ]) == length(var.r2_tokens)
    error_message = "buckets must be defined in var.buckets"
  }
}

locals {
  minio_token_resources = {
    for key, value in var.minio_tokens : key => {
      roots = [
        for bucket in value.buckets : "arn:aws:s3:::${var.buckets[bucket].name}"
      ]
      objs = [
        for bucket in value.buckets : "arn:aws:s3:::${var.buckets[bucket].name}/*"
      ]
    }
  }

  s3_read_perms = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  s3_write_perms = [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:DeleteObject",
    "s3:PutObject"
  ]

  minio_token_policies = {
    for key, value in var.minio_tokens : key => {
      policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ${value.write == true ? jsonencode(local.s3_write_perms) : jsonencode(local.s3_read_perms)},
      "Resource": ${jsonencode(concat(local.minio_token_resources[key].roots, local.minio_token_resources[key].objs))}
    }
  ]
}
EOF
    }
  }
}

resource "minio_s3_bucket" "bucket" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "minio"
  }

  bucket = each.value.name
  acl    = each.value.acl
}

resource "minio_iam_user" "user" {
  for_each = var.minio_tokens

  name = each.value.name
}

resource "minio_iam_policy" "policy" {
  for_each = var.minio_tokens

  name       = each.value.name
  policy     = local.minio_token_policies[each.key].policy
  depends_on = [minio_s3_bucket.bucket, minio_iam_user.user]
}

resource "minio_iam_user_policy_attachment" "policy_attachment" {
  for_each = var.minio_tokens

  user_name   = minio_iam_user.user[each.key].id
  policy_name = minio_iam_policy.policy[each.key].id
}

resource "minio_iam_service_account" "svc_account" {
  for_each = var.minio_tokens

  target_user = minio_iam_user.user[each.key].name
  policy      = local.minio_token_policies[each.key].policy

  depends_on = [minio_iam_policy.policy]
}

resource "minio_ilm_policy" "lifecycle" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "minio" && lookup(value, "retention", null) != null
  }

  bucket = minio_s3_bucket.bucket[each.key].id
  rule {
    id         = "expire-${each.value.retention}d"
    expiration = "${each.value.retention}d"
  }
}

resource "cloudflare_r2_bucket" "this" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "r2"
  }
  account_id = lookup(each.value, "account_id", var.cloudflare_account_id)
  name       = each.value.name
}

data "cloudflare_api_token_permission_groups" "this" {}

resource "cloudflare_api_token" "this" {
  for_each = var.r2_tokens

  name = format(
    "r2-%s-%s-%s",
    join("-", each.value.buckets),
    each.value.write == true ? "write" : "read",
    random_bytes.r2_tokens[each.key].hex,
  )

  policy {
    permission_groups = compact([
      data.cloudflare_api_token_permission_groups.this.r2["Workers R2 Storage Bucket Item Read"],
      each.value.write ? data.cloudflare_api_token_permission_groups.this.r2["Workers R2 Storage Bucket Item Write"] : null,
    ])
    resources = {
      for bucket in each.value.buckets : format(
        "com.cloudflare.edge.r2.bucket.%s_default_%s",
        lookup(each.value, "account_id", var.cloudflare_account_id),
        var.buckets[bucket].name,
      ) => "*"
    }
  }
}

resource "random_bytes" "r2_tokens" {
  for_each = var.r2_tokens
  length   = 4
}
