output "ssh_public_key_name" {
  value = aws_key_pair.prod.key_name
}

output "ssh_public_key_prod" {
  value = aws_key_pair.prod.key_name
}

output "ssh_public_key_stage" {
  value = aws_key_pair.stage.key_name
}

output "aws_key_pairs" {
  value = local.aws_key_pairs
}

output "docdb_password_admin" {
  value = aws_ssm_parameter.docdb_password_admin.value
}

output "docdb_password_client" {
  value = aws_ssm_parameter.docdb_password_client.value
}

output "mysql_password" {
  value = aws_ssm_parameter.mysql_password.value
}

output "sftp_username" {
  value = aws_ssm_parameter.sftp_username.value
}

output "sftp_password" {
  value = aws_ssm_parameter.sftp_password.value
}
