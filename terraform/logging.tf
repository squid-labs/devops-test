resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 7
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_log_group.name
}