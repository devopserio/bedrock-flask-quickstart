resource "aws_iam_instance_profile" "bedrockflask" {
  name = "bedrockflask-${random_string.rando.result}"
  role = aws_iam_role.bedrockflask.name
}

resource "aws_iam_role" "bedrockflask" {
  name = "bedrockflask-${random_string.rando.result}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
            Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
        ]
    })

    tags = {
        Name = "bedrockflask-${random_string.rando.result}"
    }

 }

#IAM Role for bedrock secrets

resource "aws_iam_policy" "bedrockflaskquickstart_secrets_policy" {
  name        = "bedrockflask-quickstart-secrets-manager-policy-${random_string.rando.result}"
  description = "Policy to access secrets in Secrets Manager from EKS for flask AI demo and django portal"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
         "secretsmanager:DescribeSecret",
         "secretsmanager:GetResourcePolicy",
        "secretsmanager:ListSecretVersionIds"
        ],
        Resource = [
          "${aws_secretsmanager_secret.flask_secret_key.arn}", "${aws_secretsmanager_secret.flask_secret_key.arn}/*",
          "${aws_secretsmanager_secret.postgres_db_name.arn}", "${aws_secretsmanager_secret.postgres_db_name.arn}/*",
          "${aws_secretsmanager_secret.POSTGRES_USER.arn}", "${aws_secretsmanager_secret.POSTGRES_USER.arn}/*",
          "${aws_secretsmanager_secret.POSTGRES_PASSWORD.arn}", "${aws_secretsmanager_secret.POSTGRES_PASSWORD.arn}/*",
          "${aws_secretsmanager_secret.postgres_db_endpoint.arn}", "${aws_secretsmanager_secret.postgres_db_endpoint.arn}/*",
          "${aws_secretsmanager_secret.POSTGRES_PORT.arn}", "${aws_secretsmanager_secret.POSTGRES_PORT.arn}/*",
          "${aws_secretsmanager_secret.mail_default_sender.arn}", "${aws_secretsmanager_secret.mail_default_sender.arn}/*",
          "${aws_secretsmanager_secret.mail_server.arn}", "${aws_secretsmanager_secret.mail_server.arn}/*",
          "${aws_secretsmanager_secret.mail_port.arn}", "${aws_secretsmanager_secret.mail_port.arn}/*",
          "${aws_secretsmanager_secret.mail_use_tls.arn}", "${aws_secretsmanager_secret.mail_use_tls.arn}/*",
          "${aws_secretsmanager_secret.MAIL_PASSWORD.arn}", "${aws_secretsmanager_secret.MAIL_PASSWORD.arn}/*",
          "${aws_secretsmanager_secret.additional_secrets.arn}", "${aws_secretsmanager_secret.additional_secrets.arn}/*",
          "${aws_secretsmanager_secret.admin_users.arn}", "${aws_secretsmanager_secret.admin_users.arn}/*"
        ]
      }
    ]
  })
}


# uncomment if using KMS key
#resource "aws_iam_policy" "kms_access_policy" {
#  name   = "devopseraidemo-kms-access-policy-${random_string.rando.result}"
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Effect   = "Allow",
#        Action   = [
#          "kms:Encrypt",
#          "kms:Decrypt",
#         "kms:ReEncrypt*",
#          "kms:GenerateDataKey*",
#          "kms:DescribeKey"
 #       ],
 #       Resource = "${aws_kms_key.bedrockflaskquickstart_kms_key.id}"
 #     },
 #   ]
#  })
#}

resource "aws_iam_role_policy_attachment" "bedrockflask-policy" {
  role = aws_iam_role.bedrockflask.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bedrockflask-secrets-policy" {
  role = aws_iam_role.bedrockflask.name
  policy_arn = aws_iam_policy.bedrockflaskquickstart_secrets_policy.arn
}

# uncomment if using KMS key
#resource "aws_iam_role_policy_attachment" "bedrockflask-kms-policy" {
#  role = aws_iam_role.bedrockflask.name
#  policy_arn = aws_iam_policy.devopseraidemo_kms_access_policy.arn
#}