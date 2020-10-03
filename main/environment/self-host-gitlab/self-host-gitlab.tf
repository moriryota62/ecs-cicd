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
  vpc_id        = "vpc-0ee6b3d1bee520caf"
  subnet_id     = "subnet-0ca338e6f1171bc23"

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
  ec2_instance_type          = "t2.medium"
  ec2_subnet_id              = local.subnet_id
  ec2_root_block_volume_size = "30"
  ec2_key_name               = "mori"

  sg_ingresses = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["106.133.21.37/32"]
      description = "http mori pc"
    },
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["106.133.21.37/32"]
      description = "ssh mori pc"
    }
  ]

  cloudwatch_enable_schedule = true
  cloudwatch_start_schedule  = "cron(0 0 ? * MON-FRI *)"
  cloudwatch_stop_schedule   = "cron(0 10 ? * MON-FRI *)"

  dlm_enable_snapshot = true
  dlm_snaphost_time   = "15:00"
  dlm_snaphost_count  = 1
}