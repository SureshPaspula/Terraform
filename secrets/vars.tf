variable "tags" {
  type = map
}

variable "api_jwt_key" {}

variable "docker_token" {}

variable "docker_user" {}

variable "github_password" {}

variable "github_user" {}

variable "hdinsight_password" {}

variable "mail_password" {}

variable "mail_username" {}

variable "mysql_password" {}

variable "docdb_password_admin" {}

variable "docdb_password_client" {}

variable "sftp_username" {}

variable "sftp_password" {}

variable "pgp_passphrase" {}

variable "ssh_public_key_prod" {
  default = "~/.ssh/coretechs-prod.pub"
}

variable "ssh_public_key_stage" {
  default = "~/.ssh/coretechs-stage.pub"
}

locals {
  aws_key_pairs = {
    prod  = aws_key_pair.prod.key_name
    stage = aws_key_pair.stage.key_name
  }
}
