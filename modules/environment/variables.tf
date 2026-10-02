variable "environment" {
  description = "Environment name used in resource names and tags."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the environment VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Two subnet CIDRs for the public load balancer subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Two subnet CIDRs for private application instances."
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "Use one cost-saving NAT gateway or one NAT gateway per AZ."
  type        = string

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either \"single\" or \"per_az\"."
  }
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks permitted to connect to the public load balancer over HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "EC2 instance type for the application Auto Scaling group."
  type        = string
}

variable "min_size" {
  description = "Minimum number of application instances."
  type        = number

  validation {
    condition     = var.min_size >= 0
    error_message = "min_size must be zero or greater."
  }
}

variable "desired_capacity" {
  description = "Initial desired number of application instances."
  type        = number

  validation {
    condition     = var.desired_capacity >= var.min_size && var.desired_capacity <= var.max_size
    error_message = "desired_capacity must be between min_size and max_size."
  }
}

variable "max_size" {
  description = "Maximum number of application instances."
  type        = number

  validation {
    condition     = var.max_size >= var.min_size
    error_message = "max_size must be greater than or equal to min_size."
  }
}

variable "app_message" {
  description = "Text displayed by the example web page."
  type        = string
}

variable "enable_deletion_protection" {
  description = "Protect the environment load balancer from accidental deletion."
  type        = bool
  default     = false
}
