module "docker_server" {
  source = "../docker_server"

  client = var.client
  prefix = var.prefix
  tags   = var.tags

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  private_hosted_zone = var.private_hosted_zone

  root_key_name = var.root_key_name
  iam_profile   = var.iam_profile

  environment = var.environment

  instance_count = var.instance_count
  instance_type  = var.instance_type

  security_groups    = var.security_groups
  sync_groups        = var.sync_groups
  main_bucket        = var.main_bucket
  main_bucket_region = var.main_bucket_region

  additional_setup = templatefile("${path.module}/templates/setup.sh", {
    additional_setup = var.additional_setup
    start_api_server = templatefile("${path.module}/templates/start_api_server.sh", {
      port       = var.port,
      docker_tag = var.docker_tag,
    })
    mongodb_host            = var.mongodb_host
    mongodb_port            = 27017
    run_telnet_health_check = file("${path.module}/templates/run_telnet_health_check.sh")
    run_api_health_checks   = file("${path.module}/templates/run_api_health_checks.sh")
  })
}

resource "aws_lb_target_group_attachment" "main" {
  count = var.instance_count

  target_group_arn = var.target_group_arn
  target_id        = module.docker_server.instance_ids[count.index]
  port             = var.port
}
