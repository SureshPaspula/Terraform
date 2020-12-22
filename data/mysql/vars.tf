variable "prefix" {}

variable "client" {}

variable "environment" {}

variable "tags" {
  type = map
}

# Database params
variable "db_subnets" {
  type = list
}

variable "security_groups" {
  type = list
}

variable "instance_class" {
  default = "db.m5.xlarge"
}

variable "allocated_storage" {
  default = 200
}

variable "admin_username" {
  default = "coretechsadmin"
}

variable "admin_password" {}

locals {
  connection_uri = format("mysql://%s:%s@%s",
    module.db.this_db_instance_username,
    module.db.this_db_instance_password,
    module.db.this_db_instance_endpoint
  )
}
