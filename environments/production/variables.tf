variable "aws_region" {
  description = "AWS region for production resources."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "Production VPC IPv4 CIDR."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Production public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Production private subnet CIDRs."
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "Production NAT gateway placement mode."
  type        = string
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the production load balancer over HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "Production EC2 instance type."
  type        = string
}

variable "min_size" {
  description = "Minimum production instance count."
  type        = number
}

variable "desired_capacity" {
  description = "Desired production instance count."
  type        = number
}

variable "max_size" {
  description = "Maximum production instance count."
  type        = number
}

variable "app_message" {
  description = "Text displayed by the production sample page."
  type        = string
}

variable "enable_deletion_protection" {
  description = "Whether to protect the production ALB from deletion."
  type        = bool
  default     = true
}
