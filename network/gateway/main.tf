module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = var.prefix

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups

  # TODO: Audit logs
  # access_logs = {
  #   bucket = var.alb_logs_bucket
  # }

  # TODO: Security
  #listener_ssl_policy_default =

  target_groups = [
    {
      name_prefix      = "web"
      backend_protocol = "HTTP"
      backend_port     = 8000
      target_type      = "instance"
      tags             = var.tags
    },
    {
      name_prefix      = "api"
      backend_protocol = "HTTP"
      backend_port     = 8000
      target_type      = "instance"
      health_check = {
        path                = "/api/v1"
        port                = "traffic-port"
        matcher             = "200-399"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
      tags = var.tags
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags              = var.tags
  lb_tags           = var.tags
  target_group_tags = var.tags
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = module.alb.https_listener_arns[0]
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = local.target_groups["api"]
  }

  condition {
    path_pattern {
      values = ["/api/v1*"]
    }
  }
}

resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.prefix
  type    = "A"

  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }
}
