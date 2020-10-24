terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "REGION"
}

# parameter settings
locals {
  pj       = "PJ-NAME"
  vpc_cidr = "10.1.0.0/16"
  tags = {
    pj     = "PJ-NAME"
    owner = "OWNER"
  }

  subnet_public_cidrs  = ["10.1.10.0/24", "10.1.11.0/24"]
  subnet_private_cidrs = ["10.1.20.0/24", "10.1.21.0/24"]
}

module "network" {
  source = "../../../modules/environment/network"

  # common parameter
  pj   = local.pj
  tags = local.tags

  # module parameter
  vpc_cidr = local.vpc_cidr

  subnet_public_cidrs  = local.subnet_public_cidrs
  subnet_private_cidrs = local.subnet_private_cidrs
}
