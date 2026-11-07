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
      if contains(["r2", "seaweed"], value.type)
    ]) == length(var.buckets)
    error_message = "type must be one of: r2, seaweed"
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

variable "seaweed_tokens" {
  type = map(object({
    buckets = list(string)
    write   = optional(bool, false)
  }))
  default = {}
  validation {
    condition = length([
      for key, value in var.seaweed_tokens : true
      if length([
        for b_key, b_value in value.buckets : true
        if contains(keys(var.buckets), b_value)
      ]) == length(value.buckets)
    ]) == length(var.seaweed_tokens)
    error_message = "buckets must be defined in var.buckets"
  }
}

resource "cloudflare_r2_bucket" "this" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "r2"
  }
  account_id = lookup(each.value, "account_id", var.cloudflare_account_id)
  name       = each.value.name
}

data "cloudflare_api_token_permission_groups_list" "read" {
  name = urlencode("Workers R2 Storage Bucket Item Read")
}

data "cloudflare_api_token_permission_groups_list" "write" {
  name = urlencode("Workers R2 Storage Bucket Item Write")
}

resource "cloudflare_api_token" "this" {
  for_each = var.r2_tokens

  name = format(
    "r2-%s-%s-%s",
    join("-", each.value.buckets),
    each.value.write == true ? "write" : "read",
    random_bytes.r2_tokens[each.key].hex,
  )

  policies = [{
    resources = jsonencode({
      for bucket in each.value.buckets : format(
        "com.cloudflare.edge.r2.bucket.%s_default_%s",
        lookup(each.value, "account_id", var.cloudflare_account_id),
        var.buckets[bucket].name,
      ) => "*"
    })
    effect = "allow"
    permission_groups = [{
      id = data.cloudflare_api_token_permission_groups_list.read.result[0].id
      }, {
      id = data.cloudflare_api_token_permission_groups_list.write.result[0].id
    }]
  }]
}

resource "random_bytes" "r2_tokens" {
  for_each = var.r2_tokens
  length   = 4
}

resource "aws_s3_bucket" "seaweed" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "seaweed"
  }
  bucket = each.value.name
}

resource "aws_iam_user" "seaweed" {
  for_each = var.seaweed_tokens

  name = each.key
}

locals {
  aws_s3_read_bucket_actions = [
    "s3:ListBucket",
  ]
  aws_s3_write_bucket_actions = [
    "s3:ListBucket",
  ]
  aws_s3_read_actions = [
    "s3:GetObject",
  ]
  aws_s3_write_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
  ]
}

resource "aws_iam_user_policy" "seaweed" {
  for_each = var.seaweed_tokens

  user = aws_iam_user.seaweed[each.key].name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "BucketOperations"
        Effect = "Allow"

        Action = each.value.write ? local.aws_s3_write_bucket_actions : local.aws_s3_read_bucket_actions

        Resource = [
          for bucket in each.value.buckets : "arn:aws:s3:::${var.buckets[bucket].name}"
        ]
      },
      {
        Sid    = "${each.value.write ? "Write" : "Read"}Objects"
        Effect = "Allow"

        Action = each.value.write ? local.aws_s3_write_actions : local.aws_s3_read_actions

        Resource = [
          for bucket in each.value.buckets : "arn:aws:s3:::${var.buckets[bucket].name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "seaweed" {
  for_each = var.seaweed_tokens

  user = aws_iam_user.seaweed[each.key].name

  depends_on = [aws_iam_user_policy.seaweed]
}
