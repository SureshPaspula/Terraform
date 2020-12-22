data "aws_route53_zone" "main" {
  name = var.domain
}

data "aws_route53_zone" "private" {
  count        = var.private_hosted_zone ? 1 : 0
  name         = var.private_hosted_zone_name
  private_zone = true
}

resource "aws_route53_zone" "subdomain" {
  count = var.create_subdomain ? 1 : 0

  name = local.public_domain
  tags = local.tags
}

resource "aws_route53_record" "subdomain" {
  count = var.create_subdomain ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.subdomain
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.subdomain.0.name_servers.0,
    aws_route53_zone.subdomain.0.name_servers.1,
    aws_route53_zone.subdomain.0.name_servers.2,
    aws_route53_zone.subdomain.0.name_servers.3
  ]
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  create_certificate = var.create_subdomain

  domain_name = local.public_domain
  zone_id     = var.create_subdomain ? aws_route53_zone.subdomain.0.id : ""

  subject_alternative_names = [
    "*.${local.public_domain}",
  ]

  wait_for_validation = false

  tags = local.tags
}
