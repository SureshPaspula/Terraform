variable "prefix" {}
variable "tags" {
  type = map
}

variable "vpc_id" {}

variable "subnets" {
  type = list
}

variable "security_groups" {
  type = list
}

variable "certificate_arn" {
  # default = "arn:aws:acm:us-east-1:107414700874:certificate/29e79032-47fb-4242-881e-73c9c08bca31"
}

variable "zone_id" {}

locals {
  target_groups = {
    web = module.alb.target_group_arns[0]
    api = module.alb.target_group_arns[1]
  }
}
