variable "prefix" {}

variable "tags" {
  type = map
}

variable "region" {}

variable "vpc_id" {}

variable "subnets" {
  type = list
}

variable "cluster_name" {}

variable "public_domain_name" {}

variable "private_domain_name" {
  default = "coretechs.internal"
}

variable "public_hosted_zone" {}

variable "private_hosted_zone" {}

variable "worker_type" {
  description = "Kubernetes worker node size"
  default     = "t3.large"
}

locals {
  oidc_arn = module.eks.oidc_provider_arn
  oidc_uri = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
  app_urls = {
    mlflow = "${var.prefix}-mlflow.${var.public_domain_name}"
    pachyderm_main : "${var.prefix}-pach.${var.public_domain_name}"
    pachyderm_ws : "${var.prefix}-pach-ws.${var.public_domain_name}"
  }
}
