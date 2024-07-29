module "eks" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  atmos_cli_config_path = "../../../../"

  component = var.eks_component_name

  context = module.this.context
}
