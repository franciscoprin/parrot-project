locals {
  github_repos_sub = [
    for repo_name in var.trusted_github_repo_names : (
      format("repo:%s/%s:*", var.trusted_github_org, repo_name)
    )
  ]
}

module "github_actions_iam_role" {
  source = "cloudposse/iam-role/aws"
  version     = "0.19.0"

  enabled   = module.this.enabled
  context   = module.this.context

  role_description   = "IAM role with permissions to perform push on ECR repositories and EKS helm permissions"

  principals = {
    Federated = [one(module.github_oidc_provider[*].outputs.oidc_provider_arn)]
  }

  assume_role_actions = [
    "sts:AssumeRoleWithWebIdentity"
  ]

  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    },
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.github_repos_sub
    },
  ]

  # The required permissions for this role will be defined in the ECR and EKS modules.
  policy_document_count = 0
}
