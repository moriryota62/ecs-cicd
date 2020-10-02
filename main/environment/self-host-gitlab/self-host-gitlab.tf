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
  vpc_id        = "vpc-09feba99a745d9038"
  subnet_id     = "subnet-02659da058883b8bf"

  tags = {
    pj     = "ecs-cicd"
    ownner = "nobody"
  }
}

module "gitlab" {
  source = "../../../modules/environment/self-host-gitlab"

  # common parameter
  pj     = local.pj
  tags   = local.tags
  vpc_id = local.vpc_id

  # module parameter
  ec2_instance_type          = "t2.micro"
  ec2_subnet_id              = local.subnet_id
  ec2_root_block_volume_size = "30"
  ec2_key_name               = "mori"
}