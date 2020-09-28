resource "aws_ecs_task_definition" "this" {
  # family                   = var.task_name
  # cpu                      = var.task_cpu
  # memory                   = var.task_memory
  family                   = "dummy"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # task_role_arn      = var.task_role_arn
  execution_role_arn = var.task_execution_role_arn

  container_definitions = <<-JSON
  [
    {
      "name": "dummy",
      "image": "nginx:1.12",
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/${var.pj}-cluster/${var.app}",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "dummy"
        }
      }
    }
  ]
  JSON

  tags = merge(
    {
      "Name" = "dummy"
    },
    var.tags
  )
}