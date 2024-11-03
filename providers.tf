# DATA
data "aws_availability_zones" "available" {}

# RESOURCES
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
