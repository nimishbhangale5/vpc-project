terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "vpc-terraform-state-098965823532"
    key            = "vpc-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "vpc-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}