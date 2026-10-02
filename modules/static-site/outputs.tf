output "bucket_name" {
  description = "Name of the private S3 bucket receiving static site files."
  value       = aws_s3_bucket.site.bucket
}

output "distribution_id" {
  description = "ID of the CloudFront distribution in front of the site bucket."
  value       = aws_cloudfront_distribution.site.id
}

output "site_url" {
  description = "HTTPS URL of the static site."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}
