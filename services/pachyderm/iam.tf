resource "aws_iam_policy" "eks_pachyderm" {
  name        = "${var.prefix}-eks-pachyderm-storage"
  path        = "/"
  description = "Allow EKS main controller to control ALB"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${var.storage_bucket}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${var.storage_bucket}/*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "eks_main_pachyderm" {
  role       = var.worker_iam_role
  policy_arn = aws_iam_policy.eks_pachyderm.arn
}
