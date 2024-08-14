# DATA
data "aws_availability_zones" "available" {}

# RESOURCES
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
