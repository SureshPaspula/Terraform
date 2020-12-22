variable "prefix" {}

variable "client" {}

variable "environment" {}

variable "tags" {
  type = map
}

variable "cidr_block" {}

variable "create_private_hosted_zone" {
  default = false
}

variable "private_hosted_zone_name" {
  default = "coretechs.internal."
}

variable "private_hosted_zone" {
  default = ""
}

variable "enable_vpc_peering" {
  default = false
}

variable "admin_vpc_id" {
  default = ""
}

variable "admin_cidr_block" {
  default = ""
}

variable "admin_private_route_table_id" {
  default = ""
}

variable "admin_public_route_table_id" {
  default = ""
}

variable "sftp_port" {
  default = 2222
}

locals {
  enable_vpc_peering = var.enable_vpc_peering && var.client != "admin"
  eks_cluster_name   = var.prefix
}
