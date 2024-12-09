resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "tasks" {
  family                   = "${var.cluster_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "goapp"
      image     = "${var.container_registry}/goapp:latest"
      cpu       = 256
      memory    = 256
      essential = true
      environment = [
        { name ="APP_ENV", value = "production" }
      ]
      depends_on  = []
      network     = "backend"
      portMappings = [{
        containerPort = var.container_ports["goapp"]
      }]
    },
    {
      name      = "pythonapp"
      image     = "${var.container_registry}/pythonapp:latest"
      cpu       = 256
      memory    = 256
      essential = true
      environment = []
      depends_on  = []
      network     = "backend"
      portMappings = [{
        containerPort = var.container_ports["pythonapp"]
      }]
    },
    {
      name      = "webapp"
      image     = "${var.container_registry}/webapp:latest"
      cpu       = 256
      memory    = 512
      essential = true
      environment = [
        { name = "NEXT_PUBLIC_API_URL", value = "http://reverse-proxy" }
      ]
      depends_on  = ["pythonapp"]
      network     = "frontend"
      portMappings = [{
        containerPort = var.container_ports["webapp"]
      }]
    },
    {
      name      = "adminapp"
      image     = "${var.container_registry}/adminapp:latest"
      cpu       = 256
      memory    = 512
      essential = true
      environment = [
        { name = "NEXT_PUBLIC_API_URL", value = "http://reverse-proxy" }
      ]
      depends_on  = ["goapp"]
      network     = "frontend"
      portMappings = [{
        containerPort = var.container_ports["adminapp"]
      }]
    },
    {
      name      = "reverse-proxy"
      image     = "${var.container_registry}/traefik:v2.10"
      cpu       = 256
      memory    = 256
      essential = true
      environment = []
      depends_on  = []
      network     = "frontend"
      portMappings = [{
        containerPort = var.container_ports["traefik"]
      }]
    }
  ])
}

resource "aws_ecs_service" "services" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.tasks.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}