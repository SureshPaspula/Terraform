variable "prefix" {}

variable "tags" {
  type = map
}

variable "region" {}

variable "storage_size" {
  default = 40
}

variable "worker_iam_role" {}

variable "storage_bucket" {}

variable "eks_cluster_name" {}

variable "private_domain" {
  default = "coretechs.internal"
}

locals {
  pachd_url = "${var.prefix}-pach.${var.private_domain}"
}
