resource "local_file" "manifest_mlflow" {
  filename        = "${path.module}/manifest/mlflow.yaml"
  file_permission = "0666"
  content = templatefile("${path.module}/templates/mlflow.yaml", {
    database_uri = var.database_uri,
    storage_uri  = "s3://${var.storage_bucket}",
  })
}

resource "null_resource" "deploy_mlflow" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = local.deploy_mlflow
  }
  triggers = {
    always  = timestamp()
    command = local.deploy_mlflow
  }

  depends_on = [
    local_file.manifest
  ]
}
