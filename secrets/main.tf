resource "aws_key_pair" "prod" {
  key_name   = "coretechs-prod"
  public_key = file(var.ssh_public_key_prod)

  tags = var.tags
}

resource "aws_key_pair" "stage" {
  key_name   = "coretechs-stage"
  public_key = file(var.ssh_public_key_stage)

  tags = var.tags
}

resource "aws_ssm_parameter" "api_jwt_key" {
  name = "api-jwt-key"

  value = var.api_jwt_key

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docker_token" {
  name = "docker-deployment-token"

  value = var.docker_token

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docker_user" {
  name = "docker-deployment-user"

  value = var.docker_user

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "github_password" {
  name = "github-password"

  value = var.github_password

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "github_user" {
  name = "github-user"

  value = var.github_user

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "hdinsight_password" {
  name = "hdinsight-password"

  value = var.hdinsight_password

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "mail_password" {
  name = "mail-password"

  value = var.mail_password

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "mail_username" {
  name = "mail-username"

  value = var.mail_username

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "mysql_password" {
  name = "mysql-password"

  value = var.mysql_password

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docdb_password_admin" {
  name = "docdb-password-admin"

  value = var.docdb_password_admin

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docdb_password_client" {
  name = "docdb-password-client"

  value = var.docdb_password_client

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "sftp_username" {
  name = "sftp-username"

  value = var.sftp_username

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "sftp_password" {
  name = "sftp-password"

  value = var.sftp_password

  type = "SecureString"

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pgp-passphrase" {
  name = "pgp-passphrase"

  value = var.pgp_passphrase

  type = "SecureString"

  tags = var.tags

  overwrite = true

  lifecycle {
    ignore_changes = [value]
  }
}
