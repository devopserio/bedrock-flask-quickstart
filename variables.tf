variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "The CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "The CIDR block for the second public subnet"
  default     = "10.0.2.0/24"
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

variable "openai_api_key" {
  description = "The OpenAI API key"
  sensitive   = true
}

variable "flask_secret_key" {
  description = "The Flask secret key"
  sensitive   = true
}