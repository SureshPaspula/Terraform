module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.14"

  identifier = var.prefix

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  name     = "${var.client}_${var.environment}"
  username = var.admin_username
  password = var.admin_password
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = var.security_groups

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # TODO: Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval = "30"
  # monitoring_role_name = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  tags = var.tags

  # DB subnet group
  subnet_ids = var.db_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.prefix

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
