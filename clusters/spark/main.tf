# based on https://github.com/aws-samples/aws-systems-manager-create-emr-edge-node
# Autoscaling policy base on: https://aws.amazon.com/blogs/big-data/best-practices-for-resizing-and-automatic-scaling-in-amazon-emr/

data "aws_region" "current" {}

module "logging" {
  source = "../../logging"

  client      = var.client
  prefix      = "${var.prefix}-emr"
  environment = var.environment
  s3_bucket   = var.main_bucket
  s3_region   = var.main_bucket_region
}


resource "aws_emr_cluster" "main" {
  name = var.prefix

  release_label = "emr-5.29.0"
  applications  = ["Spark"]
  log_uri       = "s3n://${var.main_bucket}/logs/emr/"

  service_role     = aws_iam_role.emr_service.arn
  autoscaling_role = aws_iam_role.emr_autoscaling_service.arn

  security_configuration = aws_emr_security_configuration.main.name

  ec2_attributes {
    instance_profile = aws_iam_instance_profile.emr_instance.id
    key_name         = var.root_key_name
    subnet_id        = var.subnet_id

    additional_master_security_groups = join(",", var.master_security_groups)
    additional_slave_security_groups  = join(",", var.slave_security_groups)
  }

  master_instance_group {
    name = "${var.prefix}-emr-master"

    instance_count = 1
    instance_type  = var.master_instance_type

    ebs_config {
      size                 = "500"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  core_instance_group {
    name = "${var.prefix}-emr-core"

    instance_count = 3
    instance_type  = var.core_instance_type

    ebs_config {
      size                 = "2000"
      type                 = "gp2"
      volumes_per_instance = 1
    }

    //    autoscaling_policy = <<-EOF
    //    {
    //      "Constraints": {
    //        "MinCapacity": 3,
    //        "MaxCapacity": 10
    //      },
    //      "Rules": [
    //        {
    //          "Name": "ScaleOut",
    //          "Description": "Scale out if HDFSUtilization is high",
    //          "Action": {
    //            "SimpleScalingPolicyConfiguration": {
    //              "AdjustmentType": "CHANGE_IN_CAPACITY",
    //              "ScalingAdjustment": 1,
    //              "CoolDown": 300
    //            }
    //          },
    //          "Trigger": {
    //            "CloudWatchAlarmDefinition": {
    //              "ComparisonOperator": "GREATER_THAN",
    //              "EvaluationPeriods": 1,
    //              "MetricName": "HDFSUtilization",
    //              "Namespace": "AWS/ElasticMapReduce",
    //              "Period": 300,
    //              "Statistic": "AVERAGE",
    //              "Threshold": 75.0,
    //              "Unit": "PERCENT"
    //            }
    //          }
    //        },
    //        {
    //          "Name": "ScaleIn",
    //          "Description": "Scale in if HDFSUtilization is low",
    //          "Action": {
    //            "SimpleScalingPolicyConfiguration": {
    //              "AdjustmentType": "CHANGE_IN_CAPACITY",
    //              "ScalingAdjustment": -1,
    //              "CoolDown": 600
    //            }
    //          },
    //          "Trigger": {
    //            "CloudWatchAlarmDefinition": {
    //              "ComparisonOperator": "LESS_THAN",
    //              "EvaluationPeriods": 1,
    //              "MetricName": "HDFSUtilization",
    //              "Namespace": "AWS/ElasticMapReduce",
    //              "Period": 300,
    //              "Statistic": "AVERAGE",
    //              "Threshold": 50.0,
    //              "Unit": "PERCENT"
    //            }
    //          }
    //        }
    //      ]
    //    }
    //    EOF
  }

  ebs_root_volume_size = 100

  bootstrap_action {
    path = "s3://${var.main_bucket}/${aws_s3_bucket_object.bootstrap.id}"
    name = "sync_users"
    args = []
  }

  lifecycle {
    ignore_changes = [step]
  }

  tags = merge(var.tags, { "Name" = "${var.prefix}-emr" })

  depends_on = [
    local.bootstrap_content
  ]
}

resource "aws_s3_bucket_object" "setup_logging" {
  key     = "emr/setup_logging.sh"
  bucket  = var.main_bucket
  content = module.logging.setup_script

  server_side_encryption = "aws:kms"
}

resource "aws_s3_bucket_object" "bootstrap" {
  key     = "emr/bootstrap.sh"
  bucket  = var.main_bucket
  content = local.bootstrap_content

  server_side_encryption = "aws:kms"
}

resource "aws_emr_instance_group" "task" {
  cluster_id = aws_emr_cluster.main.id
  name       = "${var.prefix}-emr-task"

  instance_count = 3
  instance_type  = var.task_instance_type

  autoscaling_policy = <<-EOF
    {
      "Constraints": {
        "MinCapacity": 3,
        "MaxCapacity": 30
      },
      "Rules": [
        {
          "Name": "ScaleOut",
          "Description": "Scale out if YARNMemoryAvailablePercentage is low",
          "Action": {
            "SimpleScalingPolicyConfiguration": {
              "AdjustmentType": "CHANGE_IN_CAPACITY",
              "ScalingAdjustment": 2,
              "CoolDown": 300
            }
          },
          "Trigger": {
            "CloudWatchAlarmDefinition": {
              "ComparisonOperator": "LESS_THAN",
              "EvaluationPeriods": 1,
              "MetricName": "YARNMemoryAvailablePercentage",
              "Namespace": "AWS/ElasticMapReduce",
              "Period": 300,
              "Statistic": "AVERAGE",
              "Threshold": 15.0,
              "Unit": "PERCENT"
            }
          }
        },
        {
          "Name": "ScaleIn",
          "Description": "Scale in if YARNMemoryAvailablePercentage is high",
          "Action": {
            "SimpleScalingPolicyConfiguration": {
              "AdjustmentType": "CHANGE_IN_CAPACITY",
              "ScalingAdjustment": -1,
              "CoolDown": 300
            }
          },
          "Trigger": {
            "CloudWatchAlarmDefinition": {
              "ComparisonOperator": "GREATER_THAN",
              "EvaluationPeriods": 1,
              "MetricName": "YARNMemoryAvailablePercentage",
              "Namespace": "AWS/ElasticMapReduce",
              "Period": 300,
              "Statistic": "AVERAGE",
              "Threshold": 50.0,
              "Unit": "PERCENT"
            }
          }
        }
      ]
    }
    EOF
}

data "aws_s3_bucket_object" "emr_certs" {
  bucket = var.main_bucket
  key    = "emr/coretechs-emr-certs.zip"
}

data "aws_kms_alias" "emr" {
  name = "alias/emr"
}

resource "aws_emr_security_configuration" "main" {
  name = "${var.prefix}-emr"

  configuration = <<-EOF
  {
    "EncryptionConfiguration": {
      "EnableInTransitEncryption": true,
      "EnableAtRestEncryption": true,
      "AtRestEncryptionConfiguration": {
        "S3EncryptionConfiguration": {
          "EncryptionMode": "SSE-S3"
        },
        "LocalDiskEncryptionConfiguration": {
          "EncryptionKeyProviderType": "AwsKms",
          "AwsKmsKey": "${data.aws_kms_alias.emr.arn}"
        }
      },
      "InTransitEncryptionConfiguration" : {
        "TLSCertificateConfiguration" : {
          "CertificateProviderType" : "PEM",
          "S3Object" : "s3://${var.main_bucket}/emr/coretechs-emr-certs.zip"
        }
      }
    }
  }
  EOF

  depends_on = [
    data.aws_s3_bucket_object.emr_certs
  ]
}

resource "aws_route53_record" "head_node" {
  zone_id = var.private_hosted_zone
  name    = "${var.prefix}-emr-head"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_emr_cluster.main.master_public_dns]

}

locals {
  bootstrap_content = templatefile("${path.module}/templates/bootstrap.sh", {
    python_requirements = file("${path.module}/templates/requirements.txt"),
    bucket_path         = "${var.main_bucket}/logs",
    setup_logging_path  = "s3://${var.main_bucket}/${aws_s3_bucket_object.setup_logging.id}",
    prefix              = "${var.prefix}-emr",
    environment         = var.environment,
    aws_region          = var.region
  })
}
