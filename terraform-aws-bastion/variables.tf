variable "name" {
  default     = "bastion"
  description = "Bastion host instance name"
}

variable "ami" {
  default     = "ami-0739f8cdb239fe9ae"
  description = "AMI for the image to use"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Bastion Instance type"
}
