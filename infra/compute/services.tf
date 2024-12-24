

resource "aws_cloudwatch_log_group" "proxy-logs" {
  name = "/proxy-logs"

  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "api-logs" {
  name = "/api-logs"

  retention_in_days = 30
}



resource "aws_ecs_task_definition" "envoy_task_def" {
  family                   = "envoy-task-def"
  network_mode             = "awsvpc"
  execution_role_arn       = var.task_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  container_definitions = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/grpc-aws:envoy-proxy",
    "cpu": 2048,
    "memory": 4096,
    "name": "envoy-task-container",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 8000
      },
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/proxy-logs",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "proxy"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "envoy_service" {
  name            = "envoy-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.envoy_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.task_sg_id]
    subnets          = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_grp_arn
    container_name   = "envoy-task-container"
    container_port   = 8000
  }

  health_check_grace_period_seconds = 60
  enable_ecs_managed_tags           = false
}


resource "aws_ecs_task_definition" "api_task_def" {
  family                   = "api-task-def"
  network_mode             = "awsvpc"
  execution_role_arn       = var.task_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  container_definitions = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/grpc-aws:backend",
    "cpu": 2048,
    "memory": 4096,
    "name": "api-task-container",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 50051,
        "hostPort": 50051
      }
    ],
    "environment" : [
      {
        "name": "MONGO_URI",
        "value": "UPDATE_THIS"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/api-logs",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "api"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.api_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.task_sg_id]
    subnets          = var.subnet_ids
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api_discovery.arn
  }


}


