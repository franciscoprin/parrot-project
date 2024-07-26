# Data source to get AWS account ID
data "aws_caller_identity" "current" {}

# Create ECR repositories
module "ecr" {
  source = "cloudposse/ecr/aws"
  version     = "0.41.0"

  enabled                = module.this.enabled
  image_names            = var.repository_names
  context                = module.this.context
  max_image_count        = var.max_image_count
  image_tag_mutability   = "MUTABLE"
  principals_push_access = [module.role_github_action_ecr_push.arn]
  # TODO: add read access to EKS nodes
  # principals_readonly_access = [....]
}
