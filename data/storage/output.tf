output "s3_bucket" {
  value = aws_s3_bucket.main.id
}

output "main_bucket" {
  value = aws_s3_bucket.main.id
}

output "main_bucket_region" {
  value = aws_s3_bucket.main.region
}

output "upload_bucket" {
  value = aws_s3_bucket.upload.id
}

output "mlflow_bucket" {
  value = var.enable_mlflow ? aws_s3_bucket.mlflow[0].id : "not-created"
}

output "pachyderm_bucket" {
  value = var.enable_pachyderm ? aws_s3_bucket.pachyderm[0].id : "not-created"
}

output "s3_buckets" {
  value = {
    main      = aws_s3_bucket.main
    pipeline  = aws_s3_bucket.pipeline
    upload    = aws_s3_bucket.upload
    mlflow    = aws_s3_bucket.mlflow
    pachyderm = aws_s3_bucket.pachyderm
  }
}
