module "docker_server" {
  source = "../docker_server"

  client      = var.client
  prefix      = var.prefix
  environment = var.environment
  tags        = var.tags

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  private_hosted_zone = var.private_hosted_zone

  root_key_name = var.root_key_name
  iam_profile   = var.iam_profile

  instance_count   = 1
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size

  main_bucket        = var.main_bucket
  main_bucket_region = var.main_bucket_region

  security_groups = var.security_groups

  enable_public_ip = true

  additional_setup = templatefile("${path.module}/templates/setup.sh", {
    additional_setup = var.additional_setup
    environment      = var.environment
    ssh_port         = var.ssh_port
    sync_upload = templatefile("${path.module}/templates/sync_upload", {
      main_bucket   = var.main_bucket
      upload_bucket = var.upload_bucket
    })
    sync_decrypt = templatefile("${path.module}/templates/sync_decrypt", { upload_bucket = var.upload_bucket })
    start_sftp_server = templatefile("${path.module}/templates/start_sftp_server", {
      sftp_username = var.sftp_username,
      sftp_port     = var.sftp_port,
      main_bucket   = var.main_bucket
    })
  })
}

data "aws_route53_zone" "public" {
  name = var.domain_name
}

resource "aws_route53_record" "public" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.prefix
  type    = "A"
  ttl     = "300"
  records = module.docker_server.public_ips
}

resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.alias
  type    = "A"
  ttl     = "300"
  records = module.docker_server.public_ips
}
