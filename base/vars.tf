variable "account" {}

variable "client" {}

variable "environment" {}

variable "domain" {}

variable "create_subdomain" {
  default = false
}

variable "subdomain" {
  default = ""
}

variable "private_hosted_zone" {
  default = false
}

variable "private_hosted_zone_name" {
  default = "coretechs.internal."
}

locals {
  prefix = "${var.client}-${var.environment}"
  tags = {
    terraform   = true
    account     = var.account
    client      = var.client
    environment = var.environment
  }
  public_domain = var.create_subdomain ? "${var.subdomain}.${var.domain}" : var.domain
}
