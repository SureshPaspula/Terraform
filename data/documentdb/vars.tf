variable "prefix" {}

variable "tags" {
  type = map
}

variable "admin_username" {
  default = "coretechsadmin"
}

variable "admin_password" {}

variable "security_groups" {
  type = list
}

variable "db_subnets" {
  type = list
}

variable "instance_count" {
  default = 3
}

variable "instance_type" {
  default = "db.r5.large"
}
