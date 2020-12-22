variable "prefix" {}

variable "tags" {
  type = map
}

variable "enable_pachyderm" {
  default = false
}

variable "enable_mlflow" {
  default = false
}

variable "vpc_endpoint_s3" {}

variable "upload_iam_role_name" {}
