output "deploy_role_arn" {
  description = "Role ARN for the AWS_ROLE_ARN repository variable. Not a secret."
  value       = module.gha_deploy_role.arn
}

output "deploy_role_subject" {
  description = "The only OIDC sub claim the deploy role accepts."
  value       = local.deploy_subject
}

output "function_name" {
  description = "Lambda function the pipeline deploys to (FUNCTION_NAME repository variable)."
  value       = module.lambda.lambda_function_name
}

output "function_url" {
  description = "Public URL of the demo function."
  value       = module.lambda.lambda_function_url
}

output "oidc_provider_arn" {
  description = "GitHub OIDC provider the deploy role trusts."
  value       = local.oidc_provider_arn
}
