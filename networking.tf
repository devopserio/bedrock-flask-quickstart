resource "random_string" "rando" {
  length  = 4
  special = false
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = data.aws_vpc.selected.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ai-application-vpc"
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "openaiflask" {
  name        = "ai-application-sg-${random_string.rando.result}"
  description = "Security group for AI application EC2 instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.your_ip_address}/32"]
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ai-application-sg"
  }
}