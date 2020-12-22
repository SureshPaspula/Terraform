output "pachd_url" {
  value = local.pachd_url
}

output "configure_pachctl" {
  value = "echo '{\"pachd_address\":\"${local.pachd_url}:650\"}' | pachctl config set context ${var.prefix} --overwrite && pachctl config set active-context ${var.prefix}"
}
