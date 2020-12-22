output "public_dns_alias" {
  value = aws_route53_record.alias.fqdn
}

output "public_dns" {
  value = aws_route53_record.public.fqdn
}

output "sftp_port" {
  value = var.sftp_port
}

output "private_ip_addresses" {
  value = module.docker_server.private_ip_addresses
}

output "public_ip_addresses" {
  value = module.docker_server.public_ip_addresses
}

output "private_hostnames" {
  value = module.docker_server.private_hostnames
}
