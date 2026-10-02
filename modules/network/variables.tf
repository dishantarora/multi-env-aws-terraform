variable "name" {
  description = "Short environment name used in resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones paired by index with the subnet CIDR lists."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per availability zone."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Provide exactly one public subnet CIDR for each availability zone."
  }
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per availability zone."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "Provide exactly one private subnet CIDR for each availability zone."
  }
}

variable "nat_gateway_mode" {
  description = "Use a single shared NAT gateway or one NAT gateway per availability zone."
  type        = string

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either \"single\" or \"per_az\"."
  }
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}
