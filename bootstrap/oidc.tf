module "github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.11.1"

  create = var.create_oidc_provider
  url    = "https://${local.github_oidc_host}"
}

# Fails the plan early if the account has no GitHub provider to reuse
data "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 0 : 1

  url = "https://${local.github_oidc_host}"
}
