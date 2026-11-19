terraform {
  required_version = ">= 1.10.0"

  # tls, external, local and null come from the modules and are pinned here too
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.73.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.8.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.4.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.4.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.2"
    }
  }

  # Partial config, completed by backend.hcl at init
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}
