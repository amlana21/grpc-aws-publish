data "aws_caller_identity" "current" {}




resource "aws_ecs_cluster" "app_cluster" {
  name = "app-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}