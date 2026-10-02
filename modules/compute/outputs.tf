output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling group."
  value       = aws_autoscaling_group.app.name
}
