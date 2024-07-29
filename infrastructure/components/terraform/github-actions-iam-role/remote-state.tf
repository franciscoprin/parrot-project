module "github_oidc_provider" {
  count = module.this.enabled ? 1 : 0

  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  component = "github-oidc-provider"
  environment = "gbl"

  atmos_cli_config_path = "../../../"

  # privileged = var.privileged

  # ignore_errors = true

  defaults = {
    # TODO: below value is hardcoded this defaults has to be removed.
    oidc_provider_arn = "arn:aws:iam::270340338153:oidc-provider/token.actions.githubusercontent.com"
  }

  context = module.this.context
}
