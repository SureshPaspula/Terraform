data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = var.prefix
  cidr = var.cidr_block


  azs             = data.aws_availability_zones.available.names
  private_subnets = [for i in [1, 2, 3] : cidrsubnet(var.cidr_block, 8, i)]
  public_subnets  = [for i in [4, 5, 6] : cidrsubnet(var.cidr_block, 8, i)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_s3_endpoint = true

  tags = merge(var.tags, {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  })

  public_subnet_tags = merge(var.tags, {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  })

  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  })
}

resource "aws_route53_zone" "private" {
  count = var.create_private_hosted_zone ? 1 : 0
  name  = var.private_hosted_zone_name

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "additional" {
  count   = length(var.private_hosted_zone) == 0 ? 0 : 1
  zone_id = var.private_hosted_zone
  vpc_id  = module.vpc.vpc_id
}
