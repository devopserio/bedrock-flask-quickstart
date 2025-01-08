data "aws_vpc" "selected" {
  # Use one of the following methods to identify your VPC:

  # If you know the VPC ID:
  id = var.vpc_id

  # Or, if you're filtering by tags, for example:
  # tags = {
  #   Name = "your-vpc-name"
  # }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    var.public_subnet_tag_key = var.public_subnet_tag_value
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    var.private_subnet_tag_key = var.private_subnet_tag_value
  }
}

