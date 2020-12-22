/**
* IAM Role: main
*/
resource "aws_iam_role" "main" {
  name = var.prefix

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "ec2.amazonaws.com"
          ]
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  description = "Allows EC2 instances to call AWS services on your behalf."

  tags = var.tags
}

resource "aws_iam_instance_profile" "main" {
  name = var.prefix
  role = aws_iam_role.main.id
}

resource "aws_iam_policy" "param_store_read" {
  name = "${var.prefix}-param-store-read"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF

  description = "Allows read access to Systems Manager Parameter Store."
}

resource "aws_iam_role_policy_attachment" "main_param_store" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.param_store_read.arn
}

resource "aws_iam_role_policy_attachment" "main_s3_read_write" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

/**
* IAM Role: Landing Zone
*/

resource "aws_iam_role" "landing_zone" {
  name = "${var.prefix}-lz"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "ec2.amazonaws.com"
          ]
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  description = "Allows EC2 instances to call AWS services on your behalf."

  tags = var.tags
}

resource "aws_iam_instance_profile" "landing_zone" {
  name = "${var.prefix}-lz"
  role = aws_iam_role.landing_zone.id
}

resource "aws_iam_role_policy_attachment" "lz_param_store" {
  role       = aws_iam_role.landing_zone.name
  policy_arn = aws_iam_policy.param_store_read.arn
}

resource "aws_iam_role_policy_attachment" "lz_s3_read_write" {
  role       = aws_iam_role.landing_zone.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

