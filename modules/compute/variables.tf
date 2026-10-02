variable "name" {
  description = "Short environment name used in resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the load balancer and application targets."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the internet-facing load balancer."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets for application instances."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the public load balancer."
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for private application instances."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for application targets."
  type        = string
}

variable "min_size" {
  description = "Minimum Auto Scaling group size."
  type        = number
}

variable "desired_capacity" {
  description = "Desired Auto Scaling group size."
  type        = number
}

variable "max_size" {
  description = "Maximum Auto Scaling group size."
  type        = number
}

variable "app_message" {
  description = "Message rendered on the example web page."
  type        = string
}

variable "enable_deletion_protection" {
  description = "Protect the ALB from accidental deletion."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to resources created by this module."
  type        = map(string)
  default     = {}
}
