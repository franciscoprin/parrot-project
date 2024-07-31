module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"
  defaults = {
    # TODO: Remove this hardcode value from here.
    vpc_id = "vpc-0ced1f79119b44852"
    private_subnet_ids =  [
      "subnet-08f3f3f4e94817d81",
      "subnet-0bcbdfd04ae9f7af2",
      "subnet-09ed376d7dc5e3401",
    ]
  }

  atmos_cli_config_path = "../../../"
  component = "vpc"

  context = module.this.context
}

module "eks" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.5.0"

  count = 1

  atmos_cli_config_path = "../../../"
  component = "eks/cluster"

  context = module.this.context
}
