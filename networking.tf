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
resource "aws_security_group" "bedrockflask" {
  name_prefix  = "ai-application-sg-${random_string.rando.result}"
  description = "Security group for AI application EC2 instances"
  vpc_id      = data.aws_vpc.selected.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ai-application-sg"
  }
}

# Define ingress rules separately
resource "aws_security_group_rule" "bedrockflask_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.your_ip_address}/32"]
  security_group_id = aws_security_group.bedrockflask.id
  description       = "SSH access from specific IP"
}

resource "aws_security_group_rule" "bedrockflask_app" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.bedrockflask.id
  description              = "Application access from ALB"
}

resource "aws_security_group_rule" "bedrockflask_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bedrockflask.id
  description       = "Allow all outbound traffic"
}