resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Allow configured HTTP clients to reach the load balancer."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name}-alb-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP from ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow load balancer traffic to targets and health checks."
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Allow HTTP from the environment load balancer only."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name}-app-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "HTTP from the load balancer security group."
}

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound updates and Systems Manager traffic through NAT."
}
