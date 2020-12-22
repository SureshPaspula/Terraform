module "linux_instance" {
  source = "../linux_instance"

  prefix = var.prefix

  environment = var.environment

  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  root_key_name = var.root_key_name
  iam_profile   = var.iam_profile

  instance_count = 1

  instance_type = var.instance_type

  enable_public_ip = true

  sync_groups = var.sync_groups

  additional_setup = templatefile("${path.module}/setup.sh", {
    additional_setup = var.additional_setup,
    environment      = var.environment
  })

  security_groups = var.security_groups
  main_bucket     = var.main_bucket

  tags = var.tags
}

data "aws_route53_zone" "public" {
  name = var.domain_name
}

resource "aws_route53_record" "public" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.prefix
  type    = "A"
  ttl     = "300"
  records = module.linux_instance.public_ips
}

resource "aws_route53_record" "alias" {
  count = local.create_alias ? 1 : 0

  zone_id = data.aws_route53_zone.public.zone_id
  name    = "bastion"
  type    = "A"
  ttl     = "300"
  records = module.linux_instance.public_ips
}
