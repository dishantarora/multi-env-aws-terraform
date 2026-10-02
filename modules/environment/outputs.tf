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

output "static_site_url" {
  description = "HTTPS URL of the static site hosted through CloudFront."
  value       = module.static_site.site_url
}

output "static_site_bucket_name" {
  description = "Private S3 bucket receiving static site files."
  value       = module.static_site.bucket_name
}

output "static_site_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation after deployment."
  value       = module.static_site.distribution_id
}
