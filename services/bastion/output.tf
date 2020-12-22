output "private_ip_addresses" {
  value = module.linux_instance.private_ip_addresses
}

output "public_ip_addresses" {
  value = module.linux_instance.public_ip_addresses
}

output "public_ips" {
  value = module.linux_instance.public_ips
}

output "public_dns" {
  value = aws_route53_record.public.fqdn
}

output "public_dns_alias" {
  value = aws_route53_record.alias.*.fqdn
}
