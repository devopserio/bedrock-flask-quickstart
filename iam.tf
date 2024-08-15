resource "aws_iam_instance_profile" "openaiflask" {
  name = "openaiflask-${random_string.rando.result}"
  role = aws_iam_role.openaiflask.name
}

resource "aws_iam_role" "openaiflask" {
  name = "openaiflask-${random_string.rando.result}"
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
        Name = "openaiflask-${random_string.rando.result}"
    }

 }

#IAM Role for OpenAI secrets

resource "aws_iam_policy" "openaiflaskquickstart_secrets_policy" {
  name        = "openaiflask-quickstart-secrets-manager-policy-${random_string.example_secret.result}"
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
          "${aws_secretsmanager_secret.openai_api_key.arn}", "${aws_secretsmanager_secret.openai_api_key.arn}/*"
        ]
      }
    ]
  })
}


# uncomment if using KMS key
#resource "aws_iam_policy" "kms_access_policy" {
#  name   = "devopseraidemo-kms-access-policy-${random_string.example_secret.result}"
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
 #       Resource = "${aws_kms_key.openaiflaskquickstart_kms_key.id}"
 #     },
 #   ]
#  })
#}

resource "aws_iam_role_policy_attachment" "openaiflask-policy" {
  role = aws_iam_role.openaiflask.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "openaiflask-secrets-policy" {
  role = aws_iam_role.openaiflask.name
  policy_arn = aws_iam_policy.openaiflaskquickstart_secrets_policy.arn
}

# uncomment if using KMS key
#resource "aws_iam_role_policy_attachment" "openaiflask-kms-policy" {
#  role = aws_iam_role.openaiflask.name
#  policy_arn = aws_iam_policy.devopseraidemo_kms_access_policy.arn
#}