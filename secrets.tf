# Uncomment if using a KMS key
#resource "aws_kms_key" "bedrockflaskquickstart_kms_key" {
#  description             = "KMS key for bedrockflask-quickstart"
#  deletion_window_in_days = 10
#  enable_key_rotation     = true
#}


resource "aws_secretsmanager_secret" "flask_secret_key" {
  name        = "Flask-secret-key-for-ami-quickstart-${random_string.secret_suffix.result}"
  description = "Flask Secret Key"
    # If you want to use a custom KMS key
 # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "flask_secret_key" {
  secret_id     = aws_secretsmanager_secret.flask_secret_key.id
  secret_string = var.flask_secret_key
}

resource "aws_secretsmanager_secret" "postgres_db_name" {
  name        = "prod-${var.site_name}-db-name-${random_string.secret_suffix.result}"
  description = "Name of the production database"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "postgres_db_name" {
  secret_id     = aws_secretsmanager_secret.postgres_db_name.id
  secret_string = var.prod_db_name
}

resource "aws_secretsmanager_secret" "POSTGRES_USER" {
  name        = "prod-${var.site_name}-postgres-user-${random_string.secret_suffix.result}"
  description = "Username for the production database"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "POSTGRES_USER" {
  secret_id     = aws_secretsmanager_secret.POSTGRES_USER.id
  secret_string = var.POSTGRES_USER
}

resource "aws_secretsmanager_secret" "POSTGRES_PASSWORD" {
  name        = "prod-${var.site_name}-postgres-password-${random_string.secret_suffix.result}"
  description = "Password for the production database"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "POSTGRES_PASSWORD" {
  secret_id     = aws_secretsmanager_secret.POSTGRES_PASSWORD.id
  secret_string = var.POSTGRES_PASSWORD
}

resource "aws_secretsmanager_secret" "POSTGRES_PORT" {
  name        = "prod-${var.site_name}-postgres-port-${random_string.secret_suffix.result}"
  description = "Port for the production database"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "POSTGRES_PORT" {
  secret_id     = aws_secretsmanager_secret.POSTGRES_PORT.id
  secret_string = var.POSTGRES_PORT
}

resource "aws_secretsmanager_secret" "MAIL_PASSWORD" {
  name        = "prod-${var.site_name}-mail-password-${random_string.secret_suffix.result}"
  description = "Password for mail server"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "MAIL_PASSWORD" {
  secret_id     = aws_secretsmanager_secret.MAIL_PASSWORD.id
  secret_string = var.mail_password
}

resource "aws_secretsmanager_secret" "additional_secrets" {
  name        = "prod-${var.site_name}-additional-secrets-${random_string.secret_suffix.result}"
  description = "Additional secrets for the site"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "additional_secrets" {
  secret_id     = aws_secretsmanager_secret.additional_secrets.id
  secret_string = var.additional_secrets
}

resource "aws_secretsmanager_secret" "admin_users" {
  name        = "prod-${var.site_name}-admin-users-${random_string.secret_suffix.result}"
  description = "Admin users for the site"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "admin_users" {
  secret_id     = aws_secretsmanager_secret.admin_users.id
  secret_string = var.admin_users
}

resource "aws_secretsmanager_secret" "mail_default_sender" {
  name        = "prod-${var.site_name}-mail-sender-${random_string.secret_suffix.result}"
  description = "Default sender email address for mail server"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "mail_default_sender" {
  secret_id     = aws_secretsmanager_secret.mail_default_sender.id
  secret_string = var.email_for_mail_server
}

resource "aws_secretsmanager_secret" "mail_server" {
  name        = "prod-${var.site_name}-mail-server-${random_string.secret_suffix.result}"
  description = "Mail server hostname"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "mail_server" {
  secret_id     = aws_secretsmanager_secret.mail_server.id
  secret_string = var.mail_server
}

resource "aws_secretsmanager_secret" "mail_port" {
  name        = "prod-${var.site_name}-mail-port-${random_string.secret_suffix.result}"
  description = "Mail server port"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "mail_port" {
  secret_id     = aws_secretsmanager_secret.mail_port.id
  secret_string = var.mail_port
}

resource "aws_secretsmanager_secret" "mail_use_tls" {
  name        = "prod-${var.site_name}-mail-tls-${random_string.secret_suffix.result}"
  description = "Mail server TLS configuration"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "mail_use_tls" {
  secret_id     = aws_secretsmanager_secret.mail_use_tls.id
  secret_string = var.mail_use_tls
}

resource "aws_secretsmanager_secret" "postgres_db_endpoint" {
  name        = "prod-${var.site_name}-postgres-endpoint-${random_string.secret_suffix.result}"
  description = "Endpoint for the production database"
  # If you want to use a custom KMS key
  # kms_key_id = aws_kms_key.bedrockflaskquickstart_kms_key.id
}

resource "aws_secretsmanager_secret_version" "postgres_db_endpoint" {
  secret_id     = aws_secretsmanager_secret.postgres_db_endpoint.id
  secret_string = aws_db_instance.bedrockflask_db.endpoint
}
