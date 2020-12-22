module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "11.0.0"

  cluster_name = var.cluster_name

  vpc_id  = var.vpc_id
  subnets = var.subnets

  cluster_version       = "1.15"
  cluster_iam_role_name = aws_iam_role.eks_service.id

  enable_irsa = true

  node_groups = {
    default = {
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = var.worker_type

      k8s_labels      = var.tags
      additional_tags = var.tags
    }
  }

  tags = var.tags
}
