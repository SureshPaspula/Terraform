variable "client" {}

variable "prefix" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "instance_type" {
  default = "t3a.xlarge"
}

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

variable "main_bucket" {}

variable "main_bucket_region" {}

variable "short_hospital_name" {
  default = "GrayMatter"
}

variable "hospital_name" {
  default = "GrayMatter Analytics"
}

variable "api_url" {}

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
