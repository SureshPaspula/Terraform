/* EMR Service Role
* Note: Used by EMR to create or modify AWS resources
*/
resource "aws_iam_role" "emr_service" {
  name               = "${var.prefix}-emr-service"
  assume_role_policy = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "elasticmapreduce.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "emr_service" {
  role       = aws_iam_role.emr_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}


/* EMR Autoscaling Service Role
* Note: Used by EMR to Autoscale Instance Groups
*/
resource "aws_iam_role" "emr_autoscaling_service" {
  name               = "${var.prefix}-emr-autoscaling-service"
  assume_role_policy = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "application-autoscaling.amazonaws.com",
            "elasticmapreduce.amazonaws.com"
          ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "emr_autoscaling_service" {
  role       = aws_iam_role.emr_autoscaling_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}


/* EMR Instance Role
* NOTE: All instances (master, core, edge nodes) of the EMR cluster will have
* this profile
*/
resource "aws_iam_instance_profile" "emr_instance" {
  name = "${var.prefix}-emr"
  role = aws_iam_role.emr_instance.name
}

resource "aws_iam_role" "emr_instance" {
  name = "${var.prefix}-emr-instance"

  assume_role_policy = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "read_secrets" {
  name = "${var.prefix}-read-secrets"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
          "kms:*",
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

resource "aws_iam_role_policy_attachment" "emr_instance" {
  role       = aws_iam_role.emr_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "emr_instance_read_secrets" {
  role       = aws_iam_role.emr_instance.name
  policy_arn = aws_iam_policy.read_secrets.arn
}
