variable "aws_profile_name" {
  description = "The name of the AWS profile to use"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "privileged" {
  type        = bool
  description = "True if the default provider already has access to the backend"
  default     = false
}

variable "repository_names" {
  description = "A list of repository names to create"
  type        = list(string)
}

variable "max_image_count" {
  description = "Maximum number of images to keep in the ECR repository."
  type        = number
  default     = 5
}
