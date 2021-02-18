resource "aws_security_group" "bastion" {
  name        = var.name
  description = "Bastion security group"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.vpc_cidr
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
