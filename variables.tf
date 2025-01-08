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

variable "openaiflask_ami_id" {
  description = "The AMI ID for the OpenAI Flask application from AWS Marketplace"
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
  default     = "Tier"
}

variable "private_subnet_tag_value" {
  description = "The value for the private subnet tag"
  default     = "Private"
}
