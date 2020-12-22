output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "security_groups" {
  value = {
    default              = aws_security_group.default.id
    mysql                = aws_security_group.mysql.id
    mysql_client         = aws_security_group.mysql_client.id
    docdb                = aws_security_group.docdb.id
    docdb_client         = aws_security_group.docdb_client.id
    local_traffic        = aws_security_group.local_traffic.id
    public_ssh           = aws_security_group.public_ssh.id
    public_sftp          = aws_security_group.public_sftp.id
    public_load_balancer = aws_security_group.public_load_balancer.id
  }
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "vpc_endpoint_s3" {
  value = module.vpc.vpc_endpoint_s3_id
}

output "sftp_port" {
  value = var.sftp_port
}

output "eks_cluster_name" {
  value = local.eks_cluster_name
}

output "private_hosted_zone" {
  value = coalesce(aws_route53_zone.private.*.zone_id)
}
