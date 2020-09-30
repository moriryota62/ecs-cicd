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
  pj            = "ecs-cicd"
  vpc_cidr      = "10.1.0.0/16"
  public_cidrs  = ["10.1.10.0/24","10.1.11.0/24"]
  private_cidrs = ["10.1.20.0/24","10.1.21.0/24"]
  tags = {
    pj     = "ecs-cicd"
    ownner = "nobody"
  }
}

module "network" {
  source = "../../../modules/environment/network"

  # common parameter
  pj     = local.pj
  tags   = local.tags

  # module parameter
  vpc_cidr = local.vpc_cidr

  subnet_public_cidrs  = local.public_cidrs
  subnet_private_cidrs = local.private_cidrs
}