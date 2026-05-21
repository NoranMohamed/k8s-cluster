# providers.tf
# Configures Terraform and the AWS provider.

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"   # Uses version 5.x for stability
    }
  }
}

provider "aws" {
  region = var.aws_region
}
