output "connection_uri" {
  value = format("mongodb://%s:%s@%s:27017/coretechs?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred", var.admin_username, var.admin_password, aws_docdb_cluster.default.endpoint)
}

output "reader_endpoint" {
  value = aws_docdb_cluster.default.reader_endpoint
}

output "endpoint" {
  value = aws_docdb_cluster.default.endpoint
}

output "cluster_members" {
  value = aws_docdb_cluster.default.cluster_members
}
