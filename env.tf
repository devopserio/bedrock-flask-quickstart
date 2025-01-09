data "template_file" "env_config_flaskai" {
  template = file("${path.module}/.env-flaskai.tpl")

  vars = {
    flask_secret_name       = aws_secretsmanager_secret.flask_secret_key.name
    db_name_secret_name     = aws_secretsmanager_secret.postgres_db_name.name
    db_user_secret_name     = aws_secretsmanager_secret.POSTGRES_USER.name
    db_password_secret_name = aws_secretsmanager_secret.POSTGRES_PASSWORD.name
    db_host_secret_name     = aws_secretsmanager_secret.postgres_db_endpoint.name
    db_port_secret_name     = aws_secretsmanager_secret.POSTGRES_PORT.name
    email                   = aws_secretsmanager_secret.mail_default_sender.name
    mail_password_secret_name = aws_secretsmanager_secret.MAIL_PASSWORD.name
    additional_secrets      = aws_secretsmanager_secret.additional_secrets.name
    mail_server             = aws_secretsmanager_secret.mail_server.name
    mail_port               = aws_secretsmanager_secret.mail_port.name
    mail_use_tls            = aws_secretsmanager_secret.mail_use_tls.name
    admin_users_secret_name = aws_secretsmanager_secret.admin_users.name
  }
}