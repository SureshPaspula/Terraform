output "public_dns" {
  value = aws_emr_cluster.main.master_public_dns
}

output "bootstrap_script" {
  value = aws_s3_bucket_object.bootstrap.id
}

output "edge_node_dns" {
  value = aws_instance.edge_node.private_ip
}

output "edge_node_hostname" {
  value = aws_route53_record.edge_node.fqdn
}
