output "alb_security_group_id" {
  description = "Security group ID attached to the public load balancer."
  value       = aws_security_group.alb.id
  depends_on = [
    aws_vpc_security_group_ingress_rule.alb_http,
    aws_vpc_security_group_egress_rule.alb_all,
  ]
}

output "app_security_group_id" {
  description = "Security group ID attached to private application instances."
  value       = aws_security_group.app.id
  depends_on = [
    aws_vpc_security_group_ingress_rule.app_from_alb,
    aws_vpc_security_group_egress_rule.app_all,
  ]
}
