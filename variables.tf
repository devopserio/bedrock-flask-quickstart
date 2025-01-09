variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "your_ip_address" {
  description = "Your local IP address in the format of x.x.x.x"
}

variable "key_name" {
  description = "The name of the EC2 key pair to use"
}

variable "bedrockflask_ami_id" {
  description = "The AMI ID for the bedrock Flask application from AWS Marketplace"
}

variable "domain_name" {
  description = "The domain name for the application in route53"
}

variable "subdomain" {
  description = "The subdomain for the application in route53"
}

variable "flask_secret_key" {
  description = "The Flask secret key"
  sensitive   = true
}

variable "vpc_id" { 
  description = "The VPC ID"
}

variable "public_subnet_tag_key" {
  description = "The key for the public subnet tag"
  default     = "Tier"
}

variable "public_subnet_tag_value" {
  description = "The value for the public subnet tag"
  default     = "Public"
}

variable "private_subnet_tag_key" {
  description = "The key for the private subnet tag"
  default     = "OS"
}

variable "private_subnet_tag_value" {
  description = "The value for the private subnet tag"
  default     = "Ubuntu"
}

variable "dev_db_name" {
  description = "Name of the production database"
  type        = string
  sensitive   = true
}

variable "POSTGRES_USER" {
  description = "Username for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "POSTGRES_PASSWORD" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "POSTGRES_PORT" {
  description = "Port number for the PostgreSQL database"
  type        = string
  default     = "5432"
  sensitive   = true
}

variable "mail_password" {
  description = "Password for the mail server"
  type        = string
  sensitive   = true
}

variable "additional_secrets" {
  description = "Additional secrets for the application"
  type        = string
  sensitive   = true
  default     = "{}"  # Default empty JSON object
}

variable "admin_users" {
  description = "List of admin users for the application"
  type        = string
  sensitive   = true
  default     = "{}"  # Default empty JSON array
}

variable "email_for_mail_server" {
  description = "Default sender email address for the mail server"
  type        = string
  sensitive   = true
}

variable "mail_server" {
  description = "Hostname of the mail server"
  type        = string
  default     = "smtp.gmail.com"
  sensitive   = true
}

variable "mail_port" {
  description = "Port number for the mail server"
  type        = string
  default     = "587"
  sensitive   = true
}

variable "mail_use_tls" {
  description = "Whether to use TLS for mail server connection"
  type        = string
  default     = "true"
  sensitive   = true
}

variable "vpn_sg_id" {
  description = "Security group ID for the VPN"
  type        = string
}