## EKS Service Role
resource "aws_iam_role" "eks_service" {
  name        = "${var.prefix}-eks-service"
  description = "IAM Role for EKS cluster"
  tags        = var.tags

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "eks_main_service" {
  role       = aws_iam_role.eks_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_main_cluster" {
  role       = aws_iam_role.eks_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# NOTE: EKS ALB Ingress Controller Role
# This role is used by alb-ingress-controller to direct external traffic to
# services running in the Kubernetes cluster.

resource "aws_iam_role" "eks_ingress" {
  name        = "${var.prefix}-eks-alb-ingress-controller"
  description = "IAM Role to allow alb-ingress-controller to modify ALB resources"
  tags        = var.tags

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${local.oidc_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${local.oidc_uri}:sub": "system:serviceaccount:default:alb-ingress-controller"
          }
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "eks_ingress" {
  name        = "${var.prefix}-eks-alb-ingress-controller"
  path        = "/"
  description = "Allow EKS ingress controller to control ALB"

  policy = file("${path.module}/templates/eks-alb-ingress-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "eks_ingress" {
  role       = aws_iam_role.eks_ingress.name
  policy_arn = aws_iam_policy.eks_ingress.arn
}

# NOTE: EKS External DNS Controller
# This role is used by external-dns controller to create DNS records

resource "aws_iam_role" "eks_external_dns" {
  name        = "${var.prefix}-eks-external-dns-controller"
  description = "IAM Role to allow external-dns controller to modify DNS records"
  tags        = var.tags

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${local.oidc_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${local.oidc_uri}:sub": "system:serviceaccount:default:external-dns"
          }
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "eks_external_dns" {
  name        = "${var.prefix}-eks-external-dns-controller"
  path        = "/"
  description = "Allow external-dns controller to update DNS records"

  policy = <<-EOF
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "route53:ChangeResourceRecordSets"
         ],
         "Resource": [
           "arn:aws:route53:::hostedzone/${var.public_hosted_zone}",
           "arn:aws:route53:::hostedzone/${var.private_hosted_zone}"
         ]
       },
       {
         "Effect": "Allow",
         "Action": [
           "route53:ListHostedZones",
           "route53:ListResourceRecordSets"
         ],
         "Resource": [
           "*"
         ]
       }
     ]
   }
   EOF
}

resource "aws_iam_role_policy_attachment" "eks_external_dns" {
  role       = aws_iam_role.eks_external_dns.name
  policy_arn = aws_iam_policy.eks_external_dns.arn
}
