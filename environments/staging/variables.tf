variable "aws_region" {
  description = "AWS region for staging resources."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"
}

variable "vpc_cidr" {
  description = "Staging VPC IPv4 CIDR."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Staging public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Staging private subnet CIDRs."
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "Staging NAT gateway placement mode."
  type        = string
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the staging load balancer over HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "Staging EC2 instance type."
  type        = string
}

variable "min_size" {
  description = "Minimum staging instance count."
  type        = number
}

variable "desired_capacity" {
  description = "Desired staging instance count."
  type        = number
}

variable "max_size" {
  description = "Maximum staging instance count."
  type        = number
}

variable "app_message" {
  description = "Text displayed by the staging sample page."
  type        = string
}

variable "enable_deletion_protection" {
  description = "Whether to protect the staging ALB from deletion."
  type        = bool
  default     = false
}
