variable "tags" {
  type = map
}

variable "client" {}

variable "prefix" {}

variable "environment" {}

variable "region" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "root_key_name" {}

variable "edge_instance_type" {
  default = "m5.xlarge"
}

variable "master_instance_type" {
  default = "m5.xlarge"
}

variable "core_instance_type" {
  default = "m5.2xlarge"
}

variable "task_instance_type" {
  default = "m5.xlarge"
}

variable "main_bucket" {}

variable "main_bucket_region" {}

variable "master_security_groups" {
  type    = list(string)
  default = []
}

variable "slave_security_groups" {
  type    = list(string)
  default = []
}

variable "private_hosted_zone" {}
