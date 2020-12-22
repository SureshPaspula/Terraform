output "tags" {
  value = local.tags
}

output "prefix" {
  value = local.prefix
}

output "aws_key_pair" {
  value = contains(["prod", "global"], var.environment) ? "coretechs-prod" : "coretechs-stage"
}

output "domain_name" {
  value = local.public_domain
}

output "domain_ssl_cert_arn" {
  value = module.acm.this_acm_certificate_arn
}

output "domain_zone_id" {
  value = var.create_subdomain ? aws_route53_zone.subdomain.0.zone_id : data.aws_route53_zone.main.zone_id
}

output "private_hosted_zone" {
  value = join(",", data.aws_route53_zone.private.*.zone_id)
}
