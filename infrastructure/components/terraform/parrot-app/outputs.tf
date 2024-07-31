## RDS

locals {
  ssm_path_as_list        = split("/", local.rds_database_password_path)
  ssm_path_app            = trim(join("/", slice(local.ssm_path_as_list, 0, length(local.ssm_path_as_list) - 1)), "/")
  ssm_path_password_value = element(local.ssm_path_as_list, length(local.ssm_path_as_list) - 1)
  psql_message            = <<EOT
  Use the following to connect to this RDS instance:
  (You must have access to read the SSM parameter, have access to the private network if necessary, and have security group access)

  PGPASSWORD=$(chamber read ${local.ssm_path_app} ${local.ssm_path_password_value} -q) psql --host=${module.rds_instance.instance_address} --port=${var.rds_database_port} --username=${local.database_user} --dbname=${var.rds_database_name}
  EOT
}

output "rds_name" {
  description = "RDS DB name"
  value       = local.enabled ? var.rds_database_name : null
}

output "rds_port" {
  description = "RDS DB port"
  value       = local.enabled ? var.rds_database_port : null
}

output "rds_id" {
  description = "ID of the instance"
  value       = local.enabled ? module.rds_instance.instance_id : null
}

output "rds_arn" {
  description = "ARN of the instance"
  value       = local.enabled ? module.rds_instance.instance_arn : null
}

output "rds_address" {
  description = "Address of the instance"
  value       = local.enabled ? module.rds_instance.instance_address : null
}

output "rds_endpoint" {
  description = "DNS Endpoint of the instance"
  value       = local.enabled ? module.rds_instance.instance_endpoint : null
}

output "rds_subnet_group_id" {
  description = "ID of the created Subnet Group"
  value       = local.enabled ? module.rds_instance.subnet_group_id : null
}

output "rds_security_group_id" {
  description = "ID of the Security Group"
  value       = local.enabled ? module.rds_instance.security_group_id : null
}

output "rds_parameter_group_id" {
  description = "ID of the Parameter Group"
  value       = local.enabled ? module.rds_instance.parameter_group_id : null
}

output "rds_option_group_id" {
  description = "ID of the Option Group"
  value       = local.enabled ? module.rds_instance.option_group_id : null
}

output "rds_hostname" {
  description = "DNS host name of the instance"
  value       = local.enabled ? module.rds_instance.hostname : null
}

output "rds_resource_id" {
  description = "The RDS Resource ID of this instance."
  value       = local.enabled ? module.rds_instance.resource_id : null
}

output "psql_helper" {
  description = "A helper output to use with psql for connecting to this RDS instance."
  value       = local.psql_access_enabled ? local.psql_message : ""
}
