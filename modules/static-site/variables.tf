variable "name" {
  description = "Short environment name used in bucket and CloudFront resource names."
  type        = string
}

variable "tags" {
  description = "Tags applied to resources created by this module."
  type        = map(string)
  default     = {}
}
