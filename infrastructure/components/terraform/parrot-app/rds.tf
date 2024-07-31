variable "rds_dns_zone_id" {
  type        = string
  default     = ""
  description = "The ID of the DNS Zone in Route53 where a new DNS record will be created for the DB host name"
}

variable "rds_host_name" {
  type        = string
  default     = "db"
  description = "The DB host name created in Route53"
}

variable "rds_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the security groups from which to allow `ingress` traffic to the DB instance"
}

variable "rds_allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "The whitelisted CIDRs which to allow `ingress` traffic to the DB instance"
}

variable "rds_associate_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the existing security groups to associate with the DB instance"
}

variable "rds_database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
}

variable "rds_database_port" {
  type        = number
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
}

variable "rds_multi_az" {
  type        = bool
  description = "Set to true if multi AZ deployment must be supported"
  default     = false
}

variable "rds_storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "standard"
}

# variable "rds_storage_encrypted" {
#   type        = bool
#   description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
#   default     = true
# }

variable "rds_iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = 0
}

variable "rds_storage_throughput" {
  type        = number
  description = "The storage throughput value for the DB instance. Can only be set when `storage_type` is `gp3`. Cannot be specified if the `allocated_storage` value is below a per-engine threshold."
  default     = null
}

variable "rds_allocated_storage" {
  type        = number
  description = "The allocated storage in GBs"
}

variable "rds_max_allocated_storage" {
  type        = number
  description = "The upper limit to which RDS can automatically scale the storage in GBs"
  default     = 0
}

variable "rds_engine" {
  type        = string
  description = "Database engine type"
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # - mysql
  # - postgres
  # - oracle-*
  # - sqlserver-*
}

variable "rds_engine_version" {
  description = "Database engine version, depends on engine type"
  type        = string
  # https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-versions.html
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
}

variable "rds_major_engine_version" {
  description = "Database MAJOR engine version, depends on engine type"
  type        = string
  default     = ""
  # https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html
}

# variable "rds_charset_name" {
#   type        = string
#   description = "The character set name to use for DB encoding. [Oracle & Microsoft SQL only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#character_set_name). For other engines use `db_parameter`"
#   default     = null
# }

# variable "rds_license_model" {
#   type        = string
#   description = "License model for this DB. Optional, but required for some DB Engines. Valid values: license-included | bring-your-own-license | general-public-license"
#   default     = ""
# }

variable "rds_instance_class" {
  description = "Class of RDS instance"
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
  type        = string
}

# This is for custom parameters to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "rds_db_parameter_group" {
  type        = string
  description = "The DB parameter group family name. The value depends on DB engine used. See [DBParameterGroupFamily](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBParameterGroup.html#API_CreateDBParameterGroup_RequestParameters) for instructions on how to retrieve applicable value."
  # "mysql5.6"
  # "postgres9.5"
}

variable "rds_availability_zone" {
  type        = string
  default     = null
  description = "The AZ for the RDS instance. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`. If `availability_zone` is provided, the instance will be placed into the default VPC or EC2 Classic"
}

variable "rds_db_subnet_group_name" {
  type        = string
  default     = null
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`"
}

variable "rds_auto_minor_version_upgrade" {
  type        = bool
  description = "Allow automated minor version upgrade (e.g. from Postgres 9.5.3 to Postgres 9.5.4)"
  default     = true
}

variable "rds_allow_major_version_upgrade" {
  type        = bool
  description = "Allow major version upgrade"
  default     = false
}

variable "rds_apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  type        = string
  default     = "Mon:03:00-Mon:04:00"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = true
}

variable "rds_copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags from DB to a snapshot"
  default     = true
}

variable "rds_backup_retention_period" {
  type        = number
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 0
}

variable "rds_backup_window" {
  type        = string
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "22:00-03:00"
}

variable "rds_db_parameter" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a DB family to another"
}

variable "rds_db_options" {
  description = "A list of DB options to apply with an option group. Depends on DB engine"
  type = list(object({
    db_security_group_memberships  = list(string)
    option_name                    = string
    port                           = number
    version                        = string
    vpc_security_group_memberships = list(string)

    option_settings = list(object({
      name  = string
      value = string
    }))
  }))

  default     = []
}

# variable "rds_snapshot_identifier" {
#   description = "Snapshot identifier e.g: rds:production-2019-06-26-06-05. If specified, the module create cluster from the snapshot"
#   type        = string
#   default     = null
# }

# variable "rds_final_snapshot_identifier" {
#   type        = string
#   description = "Final snapshot identifier e.g.: some-db-final-snapshot-2019-06-26-06-05"
#   default     = ""
# }

variable "rds_parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = ""
}

# variable "rds_option_group_name" {
#   type        = string
#   description = "Name of the DB option group to associate"
#   default     = ""
# }

variable "rds_kms_key_arn" {
  type        = string
  description = "The ARN of the existing KMS key to encrypt storage"
  default     = ""
}

variable "rds_performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether Performance Insights are enabled."
}

variable "rds_performance_insights_kms_key_id" {
  type        = string
  default     = null
  description = "The ARN for the KMS key to encrypt Performance Insights data. Once KMS key is set, it can never be changed."
}

variable "rds_performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
}

# variable "rds_enabled_cloudwatch_logs_exports" {
#   type        = list(string)
#   default     = []
#   description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
# }

# variable "rds_ca_cert_identifier" {
#   type        = string
#   description = "The identifier of the CA certificate for the DB instance"
#   default     = null
# }

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. Valid Values are 0, 1, 5, 10, 15, 30, 60."
  default     = "0"
}

variable "rds_monitoring_role_arn" {
  type        = string
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  default     = null
}

variable "rds_iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

# variable "rds_replicate_source_db" {
#   description = "If the rds db instance is a replica, supply the source database identifier here"
#   default     = null
# }

# variable "rds_timezone" {
#   type        = string
#   description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See [MSSQL User Guide](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone) for more information."
#   default     = null
# }


locals {
  enabled = module.this.enabled

  vpc_id     = module.vpc.outputs.vpc_id

  # dns_zone_id         = one(module.dns_gbl_delegated[*].outputs.default_dns_zone_id)

  database_user     = substr(join("", random_pet.database_user.*.id), 0, 16)
  database_password = join("", random_password.database_password.*.result)

  psql_access_enabled = local.enabled && (var.rds_engine == "postgres")
}

module "rds_instance" {
  source  = "cloudposse/rds/aws"
  version = "1.1.0"

  # ca_cert_identifier                    = var.ca_cert_identifier
  # charset_name                          = var.charset_name
  # final_snapshot_identifier             = var.final_snapshot_identifier
  # option_group_name                     = var.option_group_name
  # replicate_source_db                   = var.replicate_source_db
  # snapshot_identifier                   = var.snapshot_identifier

  # Databas configurations
  db_options                            = var.rds_db_options
  db_parameter                          = var.rds_db_parameter
  db_parameter_group                    = var.rds_db_parameter_group
  parameter_group_name                  = var.rds_parameter_group_name
  engine                                = var.rds_engine
  engine_version                        = var.rds_engine_version
  instance_class                        = var.rds_instance_class


  multi_az                              = var.rds_multi_az

  # Upgrade
  allow_major_version_upgrade           = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade            = var.rds_auto_minor_version_upgrade
  maintenance_window                    = var.rds_maintenance_window
  major_engine_version                  = var.rds_major_engine_version
  apply_immediately                     = var.rds_apply_immediately

  # Credentials
  database_name                         = var.rds_database_name
  database_password                     = local.database_password
  database_port                         = var.rds_database_port
  database_user                         = local.database_user
  host_name                             = var.rds_host_name
  # dns_zone_id                           = local.dns_zone_id != null ? local.dns_zone_id : ""

  # Backup
  copy_tags_to_snapshot                 = var.rds_copy_tags_to_snapshot
  availability_zone                     = var.rds_availability_zone
  backup_retention_period               = var.rds_backup_retention_period
  backup_window                         = var.rds_backup_window
  skip_final_snapshot                   = var.rds_skip_final_snapshot

  # Monitoring:
  monitoring_interval                   = var.rds_monitoring_interval
  monitoring_role_arn                   = try(module.rds_monitoring_role[0].arn, "")
  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_kms_key_id       = var.rds_performance_insights_kms_key_id
  performance_insights_retention_period = var.rds_performance_insights_retention_period

  # Storage
  allocated_storage                     = var.rds_allocated_storage
  kms_key_arn                           = module.kms_key.key_arn # var.storage_encrypted ? module.kms_key.key_arn : null
  max_allocated_storage                 = var.rds_max_allocated_storage
  storage_encrypted                     = true # var.storage_encrypted
  storage_throughput                    = var.rds_storage_throughput
  storage_type                          = var.rds_storage_type
  iops                                  = var.rds_iops

  # Security:
  publicly_accessible                   = false
  security_group_ids                    = [module.eks[0].outputs.eks_cluster_managed_security_group_id]
  subnet_ids                            = module.vpc.outputs.private_subnet_ids
  vpc_id                                = local.vpc_id
  associate_security_group_ids          = var.rds_associate_security_group_ids
  allowed_cidr_blocks                   = var.rds_allowed_cidr_blocks
  iam_database_authentication_enabled   = true # var.iam_database_authentication_enabled

  context = module.this.context
}

resource "random_pet" "database_user" {
  count = 1

  # word length
  length = 5

  separator = ""

  keepers = {
    db_name = var.rds_database_name
  }
}

resource "random_password" "database_password" {
  count = 1

  # character length
  length = 33

  # Leave special characters out to avoid quoting and other issues.
  # Special characters have no additional security compared to increasing length.
  special          = false
  override_special = "!#$%^&*()<>-_"

  keepers = {
    db_name = var.rds_database_name
  }
}

module "rds_monitoring_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.17.0"

  count = var.rds_monitoring_interval != "0" ? 1 : 0

  name    = "${module.this.name}-rds-enhanced-monitoring-role"
  enabled = module.this.enabled && var.rds_monitoring_interval != 0
  context = module.this.context

  role_description      = "Used for enhanced monitoring of rds"
  policy_document_count = 0
  managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
  principals = {
    Service = ["monitoring.rds.amazonaws.com"]
  }
}
