terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "ap-northeast-1"
}

# common parameter settings
locals {
  pj                 = "ecs-cicd"
  vpc_id             = "vpc-b9eabcd1"
  subnet             = "subnet-855250cc"
  github_url         = "https://github.com/mori-ecs-cicd"
  registration_token = "AMHYG4BDN3YHSID24QJ34GK7ONEFE"
  tags     = {
    pj     = "ecs-cicd"
    ownner = "nobody"
  }
}

module "github-runner" {
  source = "../../../modules/environment/github-runner-ec2"

  # common parameter
  pj     = local.pj
  vpc_id = local.vpc_id
  tags   = local.tags

  # module parameter
  ec2_github_url             = local.github_url
  ec2_registration_token     = local.registration_token
  ec2_runner_name            = "${local.pj}-runner"
  ec2_runner_tags            = [local.pj]
  ec2_instance_type          = "t2.micro"
  ec2_subnet_id              = local.subnet
  ec2_root_block_volume_size = "30"
  ec2_key_name               = "mori"
}

module "ecs-cluster" {
  source = "../../../modules/environment/ecs-cluster"

  # common parameter
  pj   = local.pj
  tags = local.tags

  # module parameter
  cluster_name = "${local.pj}-cluster"
}

module "code-iam" {
  source = "../../../modules/environment/code-iam"

  # common parameter
  pj   = local.pj
}
