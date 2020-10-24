terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "REGION"
}

# common parameter settings
locals {
  pj       = "PJ-NAME"
  app      = "APP-NAME"
  app_full = "${local.pj}-${local.app}"
  vpc_id   = "VPC-ID"
  tags     = {
    pj     = "PJ-NAME"
    app    = "APP-NAME"
    owner = "OWNER"
  }
}

module "preparation" {
  source = "../../../modules/service/preparation"

  # common parameter
  tags   = local.tags
  vpc_id = local.vpc_id

  # module parameter
  ecr_repositories = [local.app_full]

  s3_service_settings_bucket_name = local.app_full

  sg_name   = local.app_full
}
