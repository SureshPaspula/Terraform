resource "local_file" "deploy_pachyderm" {
  filename = "${path.module}/deploy_pachyderm.sh"
  content = templatefile("${path.module}/templates/deploy.sh", {
    pachd_url        = local.pachd_url,
    eks_cluster_name = var.eks_cluster_name,
    bucket_name      = var.storage_bucket,
    aws_region       = var.region,
    storage_size     = var.storage_size,
    iam_role         = var.worker_iam_role
  })
}

resource "null_resource" "deploy_pachyderm" {
  provisioner "local-exec" {
    command     = local_file.deploy_pachyderm.filename
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always  = timestamp()
    content = local_file.deploy_pachyderm.content
  }
}
