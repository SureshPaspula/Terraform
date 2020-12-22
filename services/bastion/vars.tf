variable "prefix" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "instance_type" {
  default = "t3.small"
}

variable "root_key_name" {}

variable "iam_profile" {}

variable "additional_setup" {
  default = ""
}

variable "security_groups" {
  type = list(string)
}

variable "domain_name" {}

variable "main_bucket" {}

variable "sync_groups" {
  default = ["engineering", "data_science"]
}

locals {
  create_alias = var.environment == "global" ? true : false
}
