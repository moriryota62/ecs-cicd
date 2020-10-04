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
  pj         = "ecs-cicd"
  app        = "example"
  app_full   = "${local.pj}-${local.app}"
  # vpc_id     = "vpc-b9eabcd1"
  # subnet_ids = ["subnet-855250cc","subnet-0cd81d4621eda10f2"]
  vpc_id     = "vpc-01ebee9c826125662"
  subnet_ids = ["subnet-0de4a0053b586f886","subnet-0e75046eccbffc93a"]
  tags     = {
    pj     = "ecs-cicd"
    app    = "example"
    ownner = "nobody"
  }
}

data "aws_caller_identity" "self" { }
data "aws_region" "current" {}

module "alb" {
  source = "../../../modules/service/service-deploy/alb"

  # common parameter
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  lb_subnet_ids = local.subnet_ids
}

module "service" {
  source = "../../../modules/service/service-deploy/ecs-service-fargate"

  # common parameter
  pj       = local.pj
  app      = local.app
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  ## task definition
  task_execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-EcsTaskExecuteRole"

  ## service
  service_name              = "${local.app_full}-service"
  service_cluster_arn       = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:cluster/${local.pj}-cluster"
  service_desired_count     = 1
  service_allow_inbound_sgs = [module.alb.alb_sg_id]
  service_subnets           = local.subnet_ids
  service_container_name    = "dummy"
  service_container_port    = 80

  ## ELB Listener & targetgroup
  elb_arn                       = module.alb.alb_arn
  elb_prod_traffic_port         = 80
  elb_prod_traffic_protocol     = "HTTP"
  elb_backend_port              = 80
  elb_backend_protocol          = "HTTP"
  elb_backend_health_check_path = "/"

  ## CloudWatch Logs
  clowdwatch_log_groups = ["/${local.pj}-cluster/${local.app_full}-service"]

  depends_on = [module.alb]

}

module "deploy-pipeline" {
  source = "../../../modules/service/service-deploy/deploy-pipeline"

  # common parameter
  # name     = local.pj
  # app      = local.app
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  # codedeploy
  codedeploy_deployment_group_name   = "${local.app_full}-deploy-group"
  codedeploy_service_role_arn        = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CodeDeployRole"
  codedeploy_ecs_cluster_name        = "${local.pj}-cluster"
  codedeploy_ecs_service_name        = module.service.ecs_service_name
  codedeploy_prod_listener_arn       = module.service.listener_arn
  codedeploy_blue_target_group_name  = module.service.blue_target_group_name
  codedeploy_green_target_group_name = module.service.green_target_group_name

  # S3
  s3_service_settings_bucket_name = "${local.app_full}"
  s3_service_settings_bucket_arn  = "arn:aws:s3:::${local.app_full}"
  s3_artifact_store_name          = "${local.app_full}-artifact"

  # codepipeline
  codepipeline_ecr_repository_name = "${local.app_full}"
  codepipeline_pipeline_role_arn   = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CodePipelineRole"

  # cloudwatch event
  cloudwatch_event_ecr_repository_name = "${local.app_full}"
  cloudwatch_event_events_role_arn     = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CloudWatchEventsRole"
  cloudwatch_event_events_role_name    = "${local.pj}-CloudWatchEventsRole"
}
