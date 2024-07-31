## RDS

# # AWS KMS alias used for encryption/decryption of SSM secure strings
# variable "kms_alias_name_ssm" {
#   type        = string
#   default     = "alias/aws/ssm"
#   description = "KMS alias name for SSM"
# }

variable "ssm_enabled" {
  description = "If `true` create SSM keys for the database user and password."
  type        = bool
  default     = true
}

variable "ssm_key_format" {
  description = "SSM path format. The values will will be used in the following order: `var.name`, `var.ssm_key_*`"
  type        = string
  default     = "/%v/%v"
}

variable "ssm_rds_key_db_name" {
  description = "The SSM key to save the database name. See `var.ssm_path_format`."
  type        = string
  default     = "admin/db_user"
}

variable "ssm_rds_key_user" {
  description = "The SSM key to save the user. See `var.ssm_path_format`."
  type        = string
  default     = "admin/db_user"
}

variable "ssm_rds_key_password" {
  description = "The SSM key to save the password. See `var.ssm_path_format`."
  type        = string
  default     = "admin/db_password"
}

variable "ssm_rds_key_hostname" {
  description = "The SSM key to save the hostname. See `var.ssm_path_format`."
  type        = string
  default     = "admin/db_hostname"
}

variable "ssm_rds_key_port" {
  description = "The SSM key to save the port. See `var.ssm_path_format`."
  type        = string
  default     = "admin/db_port"
}

locals {
  ssm_enabled                = local.enabled && var.ssm_enabled
  rds_database_password_path = format(var.ssm_key_format, module.this.name, var.ssm_rds_key_password)
}

resource "aws_ssm_parameter" "rds_database_name" {
  count = local.ssm_enabled ? 1 : 0

  name        = format(var.ssm_key_format, module.this.name, var.ssm_rds_key_db_name)
  value       = var.rds_database_name
  description = "RDS DB hostname"
  type        = "SecureString"
  key_id      = module.kms_key.key_id # var.kms_alias_name_ssm
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_database_user" {
  count = local.ssm_enabled ? 1 : 0

  name        = format(var.ssm_key_format, module.this.name, var.ssm_rds_key_user)
  value       = local.database_user
  description = "RDS DB user"
  type        = "SecureString"
  key_id      = module.kms_key.key_id # var.kms_alias_name_ssm
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_database_password" {
  count = local.ssm_enabled ? 1 : 0

  name        = local.rds_database_password_path
  value       = local.database_password
  description = "RDS DB password"
  type        = "SecureString"
  key_id      = module.kms_key.key_id # var.kms_alias_name_ssm
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_database_hostname" {
  count = local.ssm_enabled ? 1 : 0

  name        = format(var.ssm_key_format, module.this.name, var.ssm_rds_key_hostname)
  value       = module.rds_instance.hostname == "" ? module.rds_instance.instance_address : module.rds_instance.hostname
  description = "RDS DB hostname"
  type        = "SecureString"
  key_id      = module.kms_key.key_id # var.kms_alias_name_ssm
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_database_port" {
  count = local.ssm_enabled ? 1 : 0

  name        = format(var.ssm_key_format, module.this.name, var.ssm_rds_key_port)
  value       = var.rds_database_port
  description = "RDS DB port"
  type        = "String"
  overwrite   = true
}
