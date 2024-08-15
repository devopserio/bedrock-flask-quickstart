# Uncomment if using a KMS key
#resource "aws_kms_key" "openaiflaskquickstart_kms_key" {
#  description             = "KMS key for openaiflask-quickstart"
#  deletion_window_in_days = 10
#  enable_key_rotation     = true
#}

resource "aws_secretsmanager_secret" "flask_secret_key" {
  name        = "Flask-secret-key-for-ami-quickstart"
  description = "Flask Secret Key"
  # If you want to use a custom KMS key
 # kms_key_id = aws_kms_key.openaiflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "flask_secret_key" {
  secret_id     = aws_secretsmanager_secret.flask_secret_key.id
  secret_string = var.flask_secret_key
}


resource "aws_secretsmanager_secret" "openai_api_key" {
  name        = "OpenAI-API-Key-for-AMI-quickstart"
  description = "OpenAI API key"
  # If you want to use a custom KMS key
 # kms_key_id = aws_kms_key.openaiflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id     = aws_secretsmanager_secret.openai_api_key.id
  secret_string = var.openai_api_key
}

resource "aws_secretsmanager_secret" "gh_actions_token" {
  name        = "GH_Actions_Token-${random_string.example_secret.result}"
  description = "GitHub Actions token"
  # If you want to use a custom KMS key
 # kms_key_id = aws_kms_key.openaiflaskquickstart_kms_key.id
}



