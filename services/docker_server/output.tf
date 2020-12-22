output "instance_ids" {
  value = module.linux_instance.instance_ids
}

output "private_ip_addresses" {
  value = module.linux_instance.private_ip_addresses
}

output "public_ip_addresses" {
  value = module.linux_instance.public_ip_addresses
}

output "public_ips" {
  value = module.linux_instance.public_ips
}

output "private_hostnames" {
  value = module.linux_instance.private_hostnames
}
