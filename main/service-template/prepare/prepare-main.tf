terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  # region  = "ap-northeast-1"
  region  = "us-east-2"
}

# common parameter settings
locals {
  pj       = "ecs-cicd"
  app      = "example"
  app_full = "${local.pj}-${local.app}"
  tags     = {
    pj     = "ecs-cicd"
    app    = "example"
    ownner = "nobody"
  }
}

module "ecr" {
  source = "../../../modules/service/prepare/ecr"

  # common parameter
  tags   = local.tags

  # module parameter
  ecr_repositories = [local.app_full]
}

module "s3" {
  source = "../../../modules/service/prepare/s3"

  # common parameter
  tags   = local.tags

  # module parameter
  s3_service_settings_bucket_name = local.app_full
}
