variable "prefix" {}

variable "client" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "instance_type" {
  default = "t3.small"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "root_key_name" {}

variable "iam_profile" {}

variable "additional_setup" {
  default = ""
}

variable "instance_count" {
  default = 1
}

variable "security_groups" {
  type = list(string)
}

variable "root_volume_size" {
  default = 512
}

variable "main_bucket" {}

variable "main_bucket_region" {}

variable "upload_bucket" {}

variable "ssh_port" {
  default = 22
}

variable "sftp_username" {}

variable "sftp_port" {
  default = 2222
}

variable "domain_name" {}

variable "alias" {}

variable "private_hosted_zone" {}
