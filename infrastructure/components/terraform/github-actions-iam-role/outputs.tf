output "name" {
  description = "The name of the IAM role created"
  value       = module.github_actions_iam_role.name
}

output "id" {
  description = "The stable and unique string identifying the role"
  value       = module.github_actions_iam_role.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the role"
  value       = module.github_actions_iam_role.arn
}

output "policy" {
  description = "Role policy document in json format. Outputs always, independent of `enabled` variable"
  value       = module.github_actions_iam_role.policy
}

output "instance_profile" {
  description = "Name of the ec2 profile (if enabled)"
  value       = module.github_actions_iam_role.instance_profile
}
