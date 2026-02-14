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
      if contains(["r2", "garage"], value.type)
    ]) == length(var.buckets)
    error_message = "type must be one of: r2, garage"
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

variable "garage_tokens" {
  type = map(object({
    name          = string
    buckets       = list(string)
    write         = optional(bool, false)
    never_expires = optional(bool, true)
  }))
  default = {}
  validation {
    condition = length([
      for key, value in var.garage_tokens : true
      if length([
        for b_key, b_value in value.buckets : true
        if contains(keys(var.buckets), b_value)
      ]) == length(value.buckets)
    ]) == length(var.garage_tokens)
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

resource "garage_bucket" "this" {
  for_each = {
    for key, value in var.buckets : key => value if value.type == "garage"
  }
  name = each.value.name
}

resource "garage_access_key" "this" {
  for_each = var.garage_tokens

  name = each.value.name
}

locals {
  garage_permissions = {
    for value in flatten([
      for t_key, t_value in var.garage_tokens : [
        for bucket in t_value.buckets : {
          key            = format("%s_%s", t_key, bucket)
          bucket_key     = bucket
          access_key_key = t_key
          owner          = false
          read           = true
          write          = t_value.write
        }
      ]
    ]) : value.key => value
  }
}

resource "garage_permission" "this" {
  for_each = local.garage_permissions

  bucket_id     = garage_bucket.this[each.value.bucket_key].id
  access_key_id = garage_access_key.this[each.value.access_key_key].id
  owner         = each.value.owner
  write         = each.value.write
  read          = each.value.read
}
