resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "tasks" {
  family                   = "${var.cluster_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 8192
  memory                   = 16384
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "goapp"
      image     = "${var.container_registry}/goapp:latest"
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = var.container_ports["goapp"]
      }]
    },
    {
      name      = "pythonapp"
      image     = "${var.container_registry}/pythonapp:latest"
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = var.container_ports["pythonapp"]
      }]
    },
    {
      name      = "webapp"
      image     = "${var.container_registry}/webapp:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [{
        containerPort = var.container_ports["webapp"],
        hostPort = var.container_ports["webapp"]
      }]
    },
    {
      name      = "adminapp"
      image     = "${var.container_registry}/adminapp:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [{
        containerPort = var.container_ports["adminapp"],
        hostPort = var.container_ports["adminapp"]
      }]
    }
  ])
}

resource "aws_ecs_service" "services" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.tasks.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}