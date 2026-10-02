variable "name" {
  description = "Short environment name used in security group names."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the security groups."
  type        = string
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed to connect to the ALB over HTTP."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to security groups."
  type        = map(string)
  default     = {}
}
