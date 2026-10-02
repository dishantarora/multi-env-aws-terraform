data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(sort(data.aws_availability_zones.available.names), 0, 2)
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "multi-env-aws-terraform"
  }
}

module "network" {
  source = "../network"

  name                 = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_mode     = var.nat_gateway_mode
  tags                 = local.common_tags
}

module "security_groups" {
  source = "../security-groups"

  name                  = var.environment
  vpc_id                = module.network.vpc_id
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
  tags                  = local.common_tags
}

module "compute" {
  source = "../compute"

  name                       = var.environment
  vpc_id                     = module.network.vpc_id
  public_subnet_ids          = module.network.public_subnet_ids
  private_subnet_ids         = module.network.private_subnet_ids
  alb_security_group_id      = module.security_groups.alb_security_group_id
  app_security_group_id      = module.security_groups.app_security_group_id
  instance_type              = var.instance_type
  min_size                   = var.min_size
  desired_capacity           = var.desired_capacity
  max_size                   = var.max_size
  app_message                = var.app_message
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.common_tags
}
