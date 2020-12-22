variable "client" {}

variable "prefix" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "root_key_name" {}

variable "instance_count" {
  default = 1
}

variable "additional_setup" {
  default = ""
}

variable "enable_public_ip" {
  default = false
}

variable "enable_public_ssh" {
  default = false
}

variable "iam_profile" {}

variable "instance_type" {
  default = "t3.small"
}

variable "security_groups" {
  type = list(string)
}

variable "root_volume_size" {
  default = 8
}

variable "main_bucket" {}

variable "main_bucket_region" {}

variable "private_hosted_zone" {}

variable "sync_groups" {
  type    = list
  default = []
}
