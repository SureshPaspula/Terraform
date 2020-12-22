variable "prefix" {}

variable "tags" {
  type = map(string)
}

variable "configure_kubectl" {}

variable "storage_uri" {}

variable "database_uri" {}

locals {
  manifest_file = "${path.module}/manifest.yaml"
  deploy_mlflow = "kubectl apply -f ${local.manifest_file}"
}
