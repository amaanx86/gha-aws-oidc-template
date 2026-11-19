provider "aws" {
  region = var.region

  allowed_account_ids = [var.account_id]

  default_tags {
    tags = {
      Project     = var.project
      Environment = "DEMO"
      ManagedBy   = "terraform"
      Repository  = var.github_repository
    }
  }
}
