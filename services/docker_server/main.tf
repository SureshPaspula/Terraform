module "linux_instance" {
  source = "../linux_instance"

  client      = var.client
  prefix      = var.prefix
  environment = var.environment
  tags        = var.tags

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  private_hosted_zone = var.private_hosted_zone

  root_key_name = var.root_key_name
  iam_profile   = var.iam_profile

  instance_count = var.instance_count

  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size

  security_groups = var.security_groups

  sync_groups = var.sync_groups

  additional_setup = templatefile("${path.module}/setup.sh", {
    additional_setup = var.additional_setup
  })

  enable_public_ip   = var.enable_public_ip
  main_bucket        = var.main_bucket
  main_bucket_region = var.main_bucket_region
}
