resource "aws_security_group" "default" {
  name        = "${var.prefix}-default"
  description = "Default security group to use for most instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow ingress from admin VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [coalesce(var.admin_cidr_block, var.cidr_block)]
  }

  egress {
    description = "Allow unrestricted egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-default" })
}

resource "aws_security_group" "local_traffic" {
  name        = "${var.prefix}-local-traffic"
  description = "Security group for instances that host services for clients in the local network"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound traffic from local VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.cidr_block]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-local-traffic" })
}

resource "aws_security_group" "public_ssh" {
  name        = "${var.prefix}-public-ssh"
  description = "Security group for instances that require public SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow public access to SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-public-ssh" })
}

resource "aws_security_group" "public_sftp" {
  name        = "${var.prefix}-public-sftp"
  description = "Security group for instances that require public SFTP access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow public access to SFTP"
    from_port   = var.sftp_port
    to_port     = var.sftp_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-public-sftp" })
}

resource "aws_security_group" "public_load_balancer" {
  name        = "${var.prefix}-alb"
  description = "Security group for application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow public HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow public HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ingress"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow unrestricted egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-alb" })
}

resource "aws_security_group" "mysql" {
  name        = "${var.prefix}-mysql"
  description = "Security group to access mysql db"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all traffic from same security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow traffic from mysql clients"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.mysql_client.id]
  }

  egress {
    description = "Allow unrestricted egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-mysql" })
}

resource "aws_security_group" "mysql_client" {
  name        = "${var.prefix}-mysql_client"
  description = "Security group to assign to mysql clients"
  vpc_id      = module.vpc.vpc_id

  tags = merge(var.tags, { "Name" = "${var.prefix}-mysql_client" })
}

resource "aws_security_group" "docdb" {
  name        = "${var.prefix}-docdb"
  description = "Security group to access docdb"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all traffic from same security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow traffic from docdb clients"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.docdb_client.id]
  }

  egress {
    description = "Allow unrestricted egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-docdb" })
}

resource "aws_security_group" "docdb_client" {
  name        = "${var.prefix}-docdb-client"
  description = "Security group to attach to docdb clients"
  vpc_id      = module.vpc.vpc_id

  tags = merge(var.tags, { "Name" = "${var.prefix}-docdb-client" })
}
