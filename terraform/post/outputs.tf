output "access_key_ids" {
  value = merge(
    {
      for key, value in var.r2_tokens : format("r2:%s", key) => cloudflare_api_token.this[key].id
    },
    {
      for key, value in var.garage_tokens : format("garage:%s", key) => garage_access_key.this[key].access_key_id
    },
    {
      for key, value in var.seaweed_tokens : format("seaweed:%s", key) => aws_iam_access_key.seaweed[key].id
    }
  )
  sensitive = true
}

output "secret_access_keys" {
  value = merge(
    {
      for key, value in var.r2_tokens : format("r2:%s", key) => sha256(cloudflare_api_token.this[key].value)
    },
    {
      for key, value in var.garage_tokens : format("garage:%s", key) => garage_access_key.this[key].secret_access_key
    },
    {
      for key, value in var.seaweed_tokens : format("seaweed:%s", key) => aws_iam_access_key.seaweed[key].secret
    }
  )
  sensitive = true
}
