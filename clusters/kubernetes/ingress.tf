resource "local_file" "configure_kubectl" {
  filename = "${path.module}/configure_kubectl"
  content = templatefile("${path.module}/templates/configure_kubectl", {
    aws_region       = var.region,
    eks_cluster_name = module.eks.cluster_id,
  })
}

resource "local_file" "rbac_role" {
  filename        = "${path.module}/manifests/rbac-role.yaml"
  file_permission = "0666"
  content = templatefile("${path.module}/templates/rbac-role.yaml", {
    iam_role_arn = aws_iam_role.eks_ingress.arn
  })
}

resource "null_resource" "rbac_role" {
  provisioner "local-exec" {
    command     = "${local_file.configure_kubectl.filename} && kubectl apply -f ${local_file.rbac_role.filename}"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    script_changed  = md5(local_file.configure_kubectl.content)
    cluster_changed = module.eks.cluster_arn
    content_changed = md5(local_file.rbac_role.content)
  }
}

resource "local_file" "alb_ingress_controller" {
  filename        = "${path.module}/manifests/alb-ingress-controller.yaml"
  file_permission = "0666"
  content = templatefile("${path.module}/templates/alb-ingress-controller.yaml", {
    cluster_name = var.cluster_name
  })
}

resource "null_resource" "alb_ingress_controller" {
  provisioner "local-exec" {
    command     = "${local_file.configure_kubectl.filename} && kubectl apply -f ${local_file.alb_ingress_controller.filename}"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    script_changed  = md5(local_file.configure_kubectl.content)
    cluster_changed = module.eks.cluster_arn
    content_changed = md5(local_file.alb_ingress_controller.content)
  }

  depends_on = [
    null_resource.rbac_role
  ]
}

resource "local_file" "external_dns" {
  filename        = "${path.module}/manifests/external-dns.yaml"
  file_permission = "0666"
  content = templatefile("${path.module}/templates/external-dns.yaml", {
    public_domain  = var.public_domain_name,
    private_domain = var.private_domain_name,
    iam_role_arn   = aws_iam_role.eks_external_dns.arn
  })
}

resource "null_resource" "external_dns" {
  provisioner "local-exec" {
    command     = "${local_file.configure_kubectl.filename} && kubectl apply -f ${local_file.external_dns.filename}"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    script_changed  = md5(local_file.configure_kubectl.content)
    cluster_changed = module.eks.cluster_arn
    content_changed = md5(local_file.external_dns.content)
  }

  depends_on = [
    null_resource.alb_ingress_controller
  ]
}

resource "local_file" "ingress" {
  filename        = "${path.module}/manifests/ingress.yaml"
  file_permission = "0666"
  content = templatefile("${path.module}/templates/ingress.yaml", {
    mlflow_url         = local.app_urls.mlflow,
    pachyderm_main_url = local.app_urls.pachyderm_main,
    pachyderm_ws_url   = local.app_urls.pachyderm_ws
  })
}

resource "null_resource" "main_ingress" {
  provisioner "local-exec" {
    command     = "${local_file.configure_kubectl.filename} && kubectl apply -f ${local_file.ingress.filename}"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    always          = timestamp()
    script_changed  = md5(local_file.configure_kubectl.content)
    cluster_changed = module.eks.cluster_arn
    content_changed = local_file.ingress.content
  }

  depends_on = [
    null_resource.alb_ingress_controller
  ]
}

resource "null_resource" "metrics" {
  provisioner "local-exec" {
    command     = "${local_file.configure_kubectl.filename} && kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    script_changed  = md5(local_file.configure_kubectl.content)
    cluster_changed = module.eks.cluster_arn
  }
}
