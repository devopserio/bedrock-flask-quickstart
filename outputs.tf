output "application_url" {
  description = "The URL of the bedrock Flask application"
  value       = "https://${aws_route53_record.bedrockflask.name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.bedrockflask.dns_name
}

output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.bedrockflask[*].id
}

output "ec2_private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.bedrockflask[*].private_ip
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 instance security group"
  value       = aws_security_group.bedrockflask.id
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.bedrockflask.arn
}

output "route53_zone_id" {
  description = "The Zone ID of the Route 53 hosted zone"
  value       = data.aws_route53_zone.domain.zone_id
}

locals {
  env_template_lines = [
    "FLASK_APP=run",
    "FLASK_ENV=development",
    "",
    "FLASK_SECRET_NAME=${data.template_file.env_config_flaskai.vars.flask_secret_name}",
    "REDIS_URL=redis://localhost:6379/0",
    "REGION=us-east-1",
    "",
    "DB_NAME_SECRET_NAME=${data.template_file.env_config_flaskai.vars.db_name_secret_name}",
    "DB_USER_SECRET_NAME=${data.template_file.env_config_flaskai.vars.db_user_secret_name}",
    "DB_PASSWORD_SECRET_NAME=${data.template_file.env_config_flaskai.vars.db_password_secret_name}",
    "DB_HOST_SECRET_NAME=${data.template_file.env_config_flaskai.vars.db_host_secret_name}",
    "DB_PORT_SECRET_NAME=${data.template_file.env_config_flaskai.vars.db_port_secret_name}",
    "",
    "MAIL_SERVER=${data.template_file.env_config_flaskai.vars.mail_server}",
    "MAIL_PORT=${data.template_file.env_config_flaskai.vars.mail_port}",
    "MAIL_USE_TLS=${data.template_file.env_config_flaskai.vars.mail_use_tls}",
    "MAIL_USERNAME=${data.template_file.env_config_flaskai.vars.email}",
    "MAIL_DEFAULT_SENDER=${data.template_file.env_config_flaskai.vars.email}",
    "MAIL_PASSWORD_SECRET_NAME=${data.template_file.env_config_flaskai.vars.mail_password_secret_name}",
    "",
    "ADDITIONAL_SECRETS=${data.template_file.env_config_flaskai.vars.additional_secrets}",
    "ADMIN_USERS_SECRET_NAME=${data.template_file.env_config_flaskai.vars.admin_users_secret_name}"
  ]
}

output "rendered_env_template" {
  description = "The rendered .env template for local development"
  value       = join("\n", local.env_template_lines)
}