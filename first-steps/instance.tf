provider "aws" {
  access_key = "AKIAVIONSUPSCUMJJEAB"
  secret_key = "RZ51pyL3QFHqJTRIgc60QL40UXbG0tEitnhF9MXc"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0817d428a6fb68645"
  instance_type = "t2.micro"
}

