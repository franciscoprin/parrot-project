variable "aws_profile_name" {
  description = "The name of the AWS profile to use"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "trusted_github_repo_names" {
  description = "A list of GitHub repository names allowed to access this role."
  type        = list(string)
}

variable "trusted_github_org" {
  description = "The GitHub organization unqualified repos are assumed to belong to. Keeps `*` from meaning all orgs and all repos."
  type        = string
}
