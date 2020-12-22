output "setup_script" {
  value = templatefile("${path.module}/templates/setup_logging.sh", {
    prefix      = var.prefix,
    bucket_path = "${var.s3_bucket}/logs"
    fluentd_conf = templatefile("${path.module}/templates/fluentd.conf", {
      prefix      = var.prefix,
      client      = var.client,
      environment = var.environment,
      s3_bucket   = var.s3_bucket,
      s3_region   = var.s3_region
    })
  })
}
