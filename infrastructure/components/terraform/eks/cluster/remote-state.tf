locals {
  accounts_with_vpc = local.enabled ? {
    for i, account in var.allow_ingress_from_vpc_accounts : try(account.tenant, module.this.tenant) != null ? format("%s-%s-%s", account.tenant, account.stage, try(account.environment, module.this.environment)) : format("%s-%s", account.stage, try(account.environment, module.this.environment)) => account
  } : {}
}

module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  atmos_cli_config_path = "../../../../"

  bypass    = !local.enabled
  component = var.vpc_component_name

  defaults = {
    public_subnet_ids  = [
      "subnet-09606f3246137d92e",
      "subnet-0e3fef0db85c80655",
      "subnet-066a8f8b0ad078267"
    ]
    private_subnet_ids = [
      "subnet-08f3f3f4e94817d81",
      "subnet-0bcbdfd04ae9f7af2",
      "subnet-09ed376d7dc5e3401"
    ]
    vpc = {
      cidr = "10.111.0.0/16",
      id = "vpc-0ced1f79119b44852",
      subnet_type_tag_key = "parrotsoftware.io/subnet/type"
    }
    vpc_cidr = "10.111.0.0/16"
    vpc_id   = "vpc-0ced1f79119b44852"
    az_public_subnets_map = {
      "us-east-1a": [
        "subnet-09606f3246137d92e"
      ],
      "us-east-1b": [
        "subnet-0e3fef0db85c80655"
      ],
      "us-east-1c": [
        "subnet-066a8f8b0ad078267"
      ]
    }
    az_private_subnets_map = {
      "us-east-1a": [
        "subnet-08f3f3f4e94817d81"
      ],
      "us-east-1b": [
        "subnet-0bcbdfd04ae9f7af2"
      ],
      "us-east-1c": [
        "subnet-09ed376d7dc5e3401"
      ]
    }
  }

  context = module.this.context
}

module "github_actions_iam_role" {
  count = module.this.enabled ? 1 : 0

  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  component = "github-oidc-provider"
  environment = "gbl"

  atmos_cli_config_path = "../../../../"

  # privileged = var.privileged

  # ignore_errors = true

  defaults = {
    # TODO: below value is hardcoded this defaults has to be removed.
    name = "gbl-experiments-github-actions-iam-role"
    arn  = "arn:aws:iam::270340338153:role/gbl-experiments-github-actions-iam-role"
  }

  context = module.this.context
}

module "vpc_ingress" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  atmos_cli_config_path = "../../../../"

  for_each = local.accounts_with_vpc

  component   = var.vpc_component_name
  environment = try(each.value.environment, module.this.environment)
  stage       = try(each.value.stage, module.this.stage)
  tenant      = try(each.value.tenant, module.this.tenant)

  context = module.this.context
}
