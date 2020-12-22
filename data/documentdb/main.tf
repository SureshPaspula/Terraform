resource "aws_docdb_cluster" "default" {
  cluster_identifier = var.prefix

  master_username = var.admin_username
  master_password = var.admin_password

  storage_encrypted = true

  backup_retention_period         = 7
  preferred_backup_window         = "03:00-07:00"
  enabled_cloudwatch_logs_exports = ["audit"]

  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.custom.id
  db_subnet_group_name            = aws_docdb_subnet_group.default.id

  vpc_security_group_ids = var.security_groups

  tags = var.tags
}

resource "aws_docdb_subnet_group" "default" {
  name       = var.prefix
  subnet_ids = var.db_subnets

  tags = var.tags
}

resource "aws_docdb_cluster_parameter_group" "custom" {
  family      = "docdb3.6"
  name        = "custom"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  tags = var.tags
}

resource "aws_docdb_cluster_instance" "default" {
  count              = var.instance_count
  identifier         = "${var.prefix}-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = var.instance_type
}
