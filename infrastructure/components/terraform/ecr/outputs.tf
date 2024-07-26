output "registry_id" {
  value       = module.this.enabled ? module.ecr.registry_id : ""
  description = "Registry ID"
}

# output "repository_names" {
#   value       = module.this.enabled ? module.ecr.repository_names : ""
#   description = "Name of first repository created"
# }

output "repository_url" {
  value       = module.this.enabled ? module.ecr.repository_url : ""
  description = "URL of first repository created"
}

output "repository_arn" {
  value       = module.this.enabled ? module.ecr.repository_arn : ""
  description = "ARN of first repository created"
}

output "repository_url_map" {
  value =  module.this.enabled ? module.ecr.repository_url_map : {}
  description = "Map of repository names to repository URLs"
}

output "repository_arn_map" {
  value =  module.this.enabled ? module.ecr.repository_arn_map : {}
  description = "Map of repository names to repository ARNs"
}
