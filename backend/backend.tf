terraform {
  backend "s3" {
    bucket = "mybucket-suresh"
    key    = "terraform/suresh"
    region = "us-east-1"
  }
}
