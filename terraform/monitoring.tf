resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggered when CPU exceeds 80%"
  actions_enabled     = true

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_actions = []
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/devops-test-cluster-log"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "HighMemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  actions_enabled     = true

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_actions = []
}
