/*
* NOTE: Deploying Edge Node to EMR
*
* An Edge Node in EMR is essentially a replica of the Master Node but used as a
* location for interactive sessions more heavily. The tricky part is the the
* cluster configurations are not known ahead oftime because the server
* configurations are dynamically generate during the deployment process.  As a
* result, the Edge Node configurations are only known after an EMR cluster is
* deployed.
*
* The step required to deploy an Edge Node is the following:
* 1. Identify Master Node
* 2. Create an AMI from the Master Node to server as the image for the Edge Node.
* 3. Deploy an new EC2 instance from the newly minted AMI image.
* 4. Configure the security groups of the new EC2 instance to allow for the correct network level access.
*/

resource "aws_instance" "edge_node" {
  ami           = aws_ami.edge_node.id
  instance_type = var.edge_instance_type

  key_name             = var.root_key_name
  subnet_id            = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.emr_instance.id

  vpc_security_group_ids = setunion(
    var.master_security_groups,
    [aws_emr_cluster.main.ec2_attributes.0.emr_managed_master_security_group]
  )

  volume_tags = merge(var.tags, { "Name" = "${var.prefix}-emr-edge-node" })

  user_data = file("${path.module}/templates/setup_edge_node.sh")

  tags = merge(var.tags, { "Name" = "${var.prefix}-emr-edge-node" })
}

resource "aws_ami" "edge_node" {
  name = var.prefix

  root_device_name    = "/dev/xvda"
  virtualization_type = "hvm"
  ena_support         = true

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.edge_node.id
    volume_size = 500
  }
}

resource "aws_ebs_snapshot" "edge_node" {
  volume_id = data.aws_ebs_volume.master_node.id
  tags      = var.tags
}

data "aws_ebs_volume" "master_node" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master_node.id]
  }

  filter {
    name   = "attachment.device"
    values = ["/dev/xvda"]
  }
}

data "aws_instance" "master_node" {
  instance_tags = {
    Name = "${var.prefix}-emr"
  }

  filter {
    name   = "instance.group-id"
    values = [aws_emr_cluster.main.ec2_attributes.0.emr_managed_master_security_group]
  }
}

resource "aws_route53_record" "edge_node" {
  zone_id = var.private_hosted_zone
  name    = "${var.prefix}-emr-edge"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.edge_node.private_ip]
}
