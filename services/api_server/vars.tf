variable "client" {}

variable "prefix" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "instance_type" {
  default = "t3a.large"
}

variable "root_key_name" {}

variable "iam_profile" {}

variable "instance_count" {
  default = 1
}

variable "security_groups" {
  type = list(string)
}


variable "main_bucket" {}

variable "main_bucket_region" {}

variable "additional_setup" {
  default = ""
}

variable "mongodb_host" {}

variable "docker_tag" {
  default = "latest"
}

variable "target_group_arn" {}

variable "port" {
  default = 8000
}

variable "private_hosted_zone" {}

variable "sync_groups" {
  type    = list
  default = []
}
