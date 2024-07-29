provider "aws" {
    region = var.region
    profile = var.aws_profile_name

    default_tags {
        tags = module.this.tags
    }
}

# module "iam_roles" {
#   source = "../../account-map/modules/iam-roles"

#   profiles_enabled = false

#   context = module.this.context
# }
