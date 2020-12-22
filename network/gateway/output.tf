output "gateway_dns" {
  value = module.alb.this_lb_dns_name
}

output "app_url" {
  value = "https://${aws_route53_record.main.fqdn}"
}

output "target_groups" {
  value = local.target_groups
}
