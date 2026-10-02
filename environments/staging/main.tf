terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

module "environment" {
  source = "../../modules/environment"

  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  nat_gateway_mode           = var.nat_gateway_mode
  allowed_ingress_cidrs      = var.allowed_ingress_cidrs
  instance_type              = var.instance_type
  min_size                   = var.min_size
  desired_capacity           = var.desired_capacity
  max_size                   = var.max_size
  app_message                = var.app_message
  enable_deletion_protection = var.enable_deletion_protection
}

output "service_url" {
  description = "HTTP URL of the staging service."
  value       = module.environment.service_url
}

output "vpc_id" {
  description = "Staging VPC ID."
  value       = module.environment.vpc_id
}
