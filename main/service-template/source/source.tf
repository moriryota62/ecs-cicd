terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "ap-northeast-1"
}

# common parameter settings
locals {
  pj       = "PJ-NAME"
  app      = "APP-NAME"
  app_full = "${local.pj}-${local.app}"
  tags     = {
    pj     = "PJ-NAME"
    app    = "APP-NAME"
    owner = "OWNER"
  }
}

module "ecr" {
  source = "../../../modules/service/source/ecr"

  # common parameter
  tags   = local.tags

  # module parameter
  ecr_repositories = [local.app_full]
}

module "s3" {
  source = "../../../modules/service/source/s3"

  # common parameter
  tags   = local.tags

  # module parameter
  s3_service_settings_bucket_name = local.app_full
}
