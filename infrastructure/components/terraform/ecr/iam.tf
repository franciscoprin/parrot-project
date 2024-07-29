variable "trusted_github_repo_names" {
  description = "A list of GitHub repository names allowed to access this role."
  type        = list(string)
}

variable "trusted_github_org" {
  description = "The GitHub organization unqualified repos are assumed to belong to. Keeps `*` from meaning all orgs and all repos."
  type        = string
}

locals {
  github_repos_sub = [
    for repo_name in var.trusted_github_repo_names : (
      format("repo:%s/%s:*", var.trusted_github_org, repo_name)
    )
  ]
}

data "aws_iam_policy_document" "ecr_push_access" {
  statement {
    effect    = "Allow"
    resources = [
      "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/*"
    ]

    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = ["ecr:GetAuthorizationToken"]
  }
}

# Define the IAM Role
module "role_github_action_ecr_push" {
  source = "cloudposse/iam-role/aws"
  version     = "0.19.0"

  name      = "github-actions-ecr-push-role"
  enabled   = module.this.enabled
  context   = module.this.context

  policy_description = "Allow ECR PushAccess"
  role_description   = "IAM role with permissions to perform push on ECR repositories"

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

  policy_documents = [
    data.aws_iam_policy_document.ecr_push_access.json,
  ]
}

# Grant GitHub Actions IAM role access to push Docker images to ECR.
resource "aws_iam_policy" "ecr_push_access" {
  name        = module.this.id
  description = "Allow ECR PushAccess"
  policy      = data.aws_iam_policy_document.ecr_push_access.json
}

resource "aws_iam_role_policy_attachment" "example_role_policy_attachment" {
  role       = one(module.github_actions_iam_role[*].outputs.name)
  policy_arn = aws_iam_policy.ecr_push_access.arn
}
