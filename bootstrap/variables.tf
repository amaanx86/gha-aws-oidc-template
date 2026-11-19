variable "region" {
  description = "AWS region for the demo Lambda function."
  type        = string
  default     = "eu-west-3"
}

variable "account_id" {
  description = "AWS account ID the stack is allowed to run against."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account ID."
  }
}

variable "project" {
  description = "Project name, used as the prefix for resource names."
  type        = string
  default     = "zero-keys"
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the deploy role, as owner/name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must be in owner/name form, with no wildcards."
  }
}

variable "create_oidc_provider" {
  description = <<-EOT
    Create the GitHub OIDC provider. Set to false when the account already has one:
    IAM allows only one provider per issuer URL, and a provider owned by this stack
    would be deleted on destroy, breaking every other pipeline that relies on it.
  EOT
  type        = bool
  default     = true
}
