output "service_url" {
  description = "HTTP URL of the environment's public Application Load Balancer."
  value       = "http://${module.compute.alb_dns_name}"
}

output "vpc_id" {
  description = "ID of the environment VPC."
  value       = module.network.vpc_id
}

output "availability_zones" {
  description = "Availability zones used by this environment."
  value       = local.availability_zones
}
