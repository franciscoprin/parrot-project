### ECR Component

This module creates Amazon ECR repositories and an IAM role that will be assumed by GitHub Actions for pushing images to the repositories. This also read from or depends on the [github-oidc-provider component output](../github-oidc-provider/README.md).

### References

* [Amazon ECR Lifecycle Policy Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)
* [Terraform Null Label Module](https://github.com/cloudposse/terraform-null-label)
* [HashiCorp Repository Versioning Issue](https://github.com/opentofu/opentofu/issues/1189)
