output "connection_uri" {
  value = local.connection_uri
}

output "mlflow_db_uri" {
  value = local.connection_uri
}

output "db_endpoint" {
  value = module.db.this_db_instance_endpoint
}

output "db_address" {
  value = module.db.this_db_instance_address
}
