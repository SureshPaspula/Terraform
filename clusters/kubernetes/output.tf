output "oidc" {
  value = {
    arn = module.eks.oidc_provider_arn
    url = module.eks.cluster_oidc_issuer_url
  }
}

output "eks_service_role" {
  value = aws_iam_role.eks_service.id
}

output "eks_ingress_role" {
  value = aws_iam_role.eks_ingress.id
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}

output "worker_iam_role_name" {
  value = module.eks.worker_iam_role_name
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "kubeconfig_filename" {
  value = module.eks.kubeconfig_filename
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}

output "app_urls" {
  value = local.app_urls
}
