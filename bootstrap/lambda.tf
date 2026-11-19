# Packaged here because the module's source_path shells out to Python at plan time
data "archive_file" "bootstrap" {
  type        = "zip"
  source_file = "${path.module}/../app/index.mjs"
  output_path = "${path.module}/.build/bootstrap.zip"
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.13.0"

  function_name = local.function_name
  description   = "Zero Keys to Production demo, deployed by GitHub Actions over OIDC."
  runtime       = "nodejs22.x"
  handler       = "index.handler"
  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 5

  create_package         = false
  local_existing_package = data.archive_file.bootstrap.output_path

  # Terraform creates the function, GitHub Actions owns its code after that
  ignore_source_code_hash = true

  # Bounds abuse and cost of the public URL
  reserved_concurrent_executions = 5

  cloudwatch_logs_retention_in_days = 7

  # Lambda adds the public invoke statements itself when an auth NONE URL is created
  create_lambda_function_url = true
  authorization_type         = "NONE"
}
