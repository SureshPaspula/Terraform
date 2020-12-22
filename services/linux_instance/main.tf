data "aws_ami" "main" {
  owners = ["679593333241"] # CentOS Project

  filter {
    name   = "name"
    values = ["CentOS Linux 7*1804_2*"] # targets CentOS 7.5.1804 release
  }
}

module "logging" {
  source = "../../logging"

  client      = var.client
  prefix      = var.prefix
  environment = var.environment
  s3_bucket   = var.main_bucket
  s3_region   = var.main_bucket_region
}

resource "aws_instance" "main" {
  count = var.instance_count

  ami = data.aws_ami.main.id

  instance_type = var.instance_type

  key_name = var.root_key_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_groups

  root_block_device {
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = merge(var.tags, { "Name" = "${var.prefix}-${count.index}" })

  user_data = templatefile("${path.module}/templates/setup.sh", {
    setup_logging    = module.logging.setup_script,
    environment      = var.environment,
    sync_groups      = join(" ", distinct(concat(var.sync_groups, ["engineering"])))
    additional_setup = var.additional_setup,
  })

  iam_instance_profile = var.iam_profile

  tags = merge(var.tags, { "Name" = "${var.prefix}-${count.index}" })
}

# conditional on var.enable_public_ip
resource "aws_eip" "main" {
  count = var.enable_public_ip ? var.instance_count : 0

  instance = aws_instance.main[count.index].id
  vpc      = true

  tags = merge(var.tags, { "Name" = "${var.prefix}-${count.index}" })
}

resource "aws_route53_record" "private" {
  count = var.instance_count

  zone_id = var.private_hosted_zone
  name    = "${var.prefix}-${count.index}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.main[count.index].private_ip]
}
