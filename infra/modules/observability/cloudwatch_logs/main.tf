resource "aws_cloudwatch_log_group" "server" {
  name              = "/ecs/${var.name}/server"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "consumer" {
  name              = "/ecs/${var.name}/consumer"
  retention_in_days = var.retention_in_days
}
