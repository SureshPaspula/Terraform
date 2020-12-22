resource "aws_s3_bucket" "main" {
  bucket = "${var.prefix}-main"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = var.tags
}

resource "aws_s3_bucket" "pipeline" {
  bucket = "${var.prefix}-pipeline"
  acl    = "private"
  policy = templatefile("${path.module}/templates/s3_bucket_policy_basic.json", {
    s3_bucket       = "${var.prefix}-pipeline",
    s3_vpc_endpoint = var.vpc_endpoint_s3
  })

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

data "aws_iam_role" "upload" {
  name = var.upload_iam_role_name
}

resource "aws_s3_bucket" "upload" {
  bucket = "${var.prefix}-upload"
  acl    = "private"
  policy = templatefile("${path.module}/templates/s3_bucket_policy.json", {
    s3_bucket       = "${var.prefix}-upload",
    s3_vpc_endpoint = var.vpc_endpoint_s3,
    iam_aws_user_id = data.aws_iam_role.upload.unique_id
  })

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket" "mlflow" {
  // TODO: Restrict write access to mlflow IAM role
  count  = var.enable_mlflow ? 1 : 0
  bucket = "${var.prefix}-mlflow"
  acl    = "private"
  policy = templatefile("${path.module}/templates/s3_bucket_policy_basic.json", {
    s3_bucket       = "${var.prefix}-mlflow",
    s3_vpc_endpoint = var.vpc_endpoint_s3
  })

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket" "pachyderm" {
  count  = var.enable_pachyderm ? 1 : 0
  bucket = "${var.prefix}-pachyderm"
  acl    = "private"
  policy = templatefile("${path.module}/templates/s3_bucket_policy_basic.json", {
    s3_bucket       = "${var.prefix}-pachyderm",
    s3_vpc_endpoint = var.vpc_endpoint_s3
  })

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}
