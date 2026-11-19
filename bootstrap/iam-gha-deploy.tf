module "gha_deploy_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  name            = local.role_name
  use_name_prefix = false
  description     = "Assumed by GitHub Actions on ${local.deploy_subject} to deploy ${local.function_name}."

  max_session_duration = 3600

  # oidc_subjects renders as StringEquals, never use oidc_wildcard_subjects (StringLike)
  enable_github_oidc = true
  oidc_subjects      = [local.deploy_subject]

  create_inline_policy = true
  inline_policy_permissions = {
    DeployDemoFunctionOnly = {
      actions = [
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:UpdateFunctionCode",
      ]
      resources = [module.lambda.lambda_function_arn]
    }
  }

  # The trust policy references the provider by ARN, so it must exist first
  depends_on = [module.github_oidc_provider]
}
