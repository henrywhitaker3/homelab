data "terraform_remote_state" "infra" {
  backend = "http"
  config = {
    address  = var.infra_state_url
    username = "henrywhitaker3"
    password = var.infra_state_token
  }
}

resource "minio_iam_user" "henry" {
  name = "henry"
}

resource "minio_iam_policy" "henry" {
  name   = "henry"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "henry" {
  user_name   = minio_iam_user.henry.name
  policy_name = minio_iam_policy.henry.id
}

resource "minio_iam_service_account" "henry" {
  target_user = minio_iam_user.henry.name
  policy      = minio_iam_policy.henry.policy
}
