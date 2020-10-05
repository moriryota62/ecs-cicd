terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "ap-northeast-1"
}

# cparameter settings
locals {
  pj     = "PJ-NAME"
  vpc_id = "vpc-01ebee9c826125662"
  tags = {
    pj     = "PJ-NAME"
    ownner = "NOBODY"
  }

  ec2_gitlab_url             = "https://gitlab.com"
  ec2_registration_token     = "d47-uL1UhRyiC5X-VFuB"
  ec2_subnet                 = "subnet-0de4a0053b586f886"
  ec2_instance_type          = "t2.micro"
  ec2_root_block_volume_size = 30
  ec2_key_name               = ""
}

module "gitlab-ecs-cicd-gitlab-runner" {
  source = "../../../modules/environment/gitlab-runner-ec2"

  # common parameter
  pj     = local.pj
  vpc_id = local.vpc_id
  tags   = local.tags

  # module parameter
  ec2_gitlab_url             = local.ec2_gitlab_url
  ec2_registration_token     = local.ec2_registration_token
  ec2_runner_name            = "${local.pj}-runner"
  ec2_runner_tags            = [local.pj]
  ec2_instance_type          = local.ec2_instance_type
  ec2_subnet_id              = local.ec2_subnet
  ec2_root_block_volume_size = local.ec2_root_block_volume_size
  ec2_key_name               = local.ec2_key_name
}
