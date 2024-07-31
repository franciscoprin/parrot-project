data "aws_iam_policy_document" "eks_cluster_access" {
  statement {
    effect    = "Allow"
    resources = [module.eks_cluster.eks_cluster_arn]
    actions = [
      "eks:DescribeCluster",
    ]
  }
}

resource "aws_iam_policy" "eks_cluster_access" {
  name        = "${module.this.id}-eks-cluster-access"
  description = "Allow access to EKS Cluster"
  policy      = data.aws_iam_policy_document.eks_cluster_access.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_access_policy_attachment" {
  role       = one(module.github_actions_iam_role[*].outputs.name)
  policy_arn = aws_iam_policy.eks_cluster_access.arn
}
