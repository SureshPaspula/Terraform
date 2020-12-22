output "instance_ids" {
  value = aws_instance.main.*.id
}

output "private_ip_addresses" {
  value = aws_instance.main[*].private_ip
}

output "public_ip_addresses" {
  value = aws_instance.main[*].public_ip
}

output "public_ips" {
  value = aws_eip.main[*].public_ip
}

output "private_hostnames" {
  value = aws_route53_record.private.*.fqdn
}
