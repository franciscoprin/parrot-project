# https://medium.com/kotaicode/aws-iam-roles-for-kubernetes-pods-in-eks-5fdbb2df4ed0
# https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html
module "eks_pod_role" {
  source = "cloudposse/iam-role/aws"
  version     = "0.19.0"

  enabled   = module.this.enabled
  context   = module.this.context

  role_description   = "IAM role with permissions to grant EKS pods access to all the resources that the applications rely on."

  principals = {
    Federated = [
        format(
            "arn:aws:iam::%s:oidc-provider/%s", 
            data.aws_caller_identity.current.account_id,
            module.eks[0].outputs.eks_cluster_identity_oidc_issuer,
        )
    ]
  }

  assume_role_actions = [
    "sts:AssumeRoleWithWebIdentity"
  ]

  assume_role_conditions = [
    {
        test     = "StringEquals"
        variable = "${module.eks[0].outputs.eks_cluster_identity_oidc_issuer}:sub",
        values   = [
            format(
                "system:serviceaccount:%s:%s",
                module.this.name, # namespace  
                module.this.name, # service-account-name
            )
        ]
    },
  ]

  # The required permissions for this role will be defined in the ECR and EKS modules.
  policy_document_count = 0
}

data "aws_iam_policy_document" "eks_pod" {
  statement {
    effect    = "Allow"
    resources = [
      module.kms_key.key_arn,
    ]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }

  statement {
    effect    = "Allow"
    resources = formatlist(
      "arn:aws:ssm:%s:%s:parameter/%s/*",
      var.region,
      data.aws_caller_identity.current.account_id,
      [
        module.this.name,
        "${module.this.name}-${module.this.stage}",
        module.this.stage,
      ],
    )
    
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]
  }
}

resource "aws_iam_policy" "eks_pod" {
  name        = "${module.this.id}-policy"
  description = "Policy granting access to the EKS Pod"
  policy      = data.aws_iam_policy_document.eks_pod.json
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = module.eks_pod_role.name
  policy_arn = aws_iam_policy.eks_pod.arn
}
