locals {
  github_oidc_host = "token.actions.githubusercontent.com"

  sub_prefix     = coalesce(var.github_sub_prefix, "repo:${var.github_repository}")
  deploy_subject = "${local.sub_prefix}:ref:refs/heads/main"

  function_name = "${var.project}-demo"
  role_name     = "gha-deploy"

  oidc_provider_arn = (
    var.create_oidc_provider
    ? module.github_oidc_provider.arn
    : data.aws_iam_openid_connect_provider.github[0].arn
  )
}
