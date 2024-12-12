resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  name        = "${var.cluster_name}.local"
  vpc         = aws_vpc.ecs_vpc.id 
  description = "Service discovery namespace for ${var.cluster_name}"
}

# GOAPP Task and Service
resource "aws_service_discovery_service" "goapp_service" {
  name = "goapp"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_task_definition" "goapp_task" {
  family                   = "${var.cluster_name}-goapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "goapp"
    image     = "${var.container_registry}/goapp:latest"
    cpu       = 512
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = var.container_ports["goapp"]
    }]
  }])
}

resource "aws_ecs_service" "goapp_service" {
  name            = "${var.cluster_name}-goapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.goapp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.goapp_service.arn
  }

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# PYTHONAPP Task and Service
resource "aws_service_discovery_service" "pythonapp_service" {
  name = "pythonapp"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_task_definition" "pythonapp_task" {
  family                   = "${var.cluster_name}-pythonapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "pythonapp"
    image     = "${var.container_registry}/pythonapp:latest"
    cpu       = 512
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = var.container_ports["pythonapp"]
    }]
  }])
}

resource "aws_ecs_service" "pythonapp_service" {
  name            = "${var.cluster_name}-pythonapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.pythonapp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.pythonapp_service.arn
  }

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# ADMINAPP Task and Service
resource "aws_ecs_task_definition" "adminapp_task" {
  family                   = "${var.cluster_name}-adminapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "adminapp"
    image     = "${var.container_registry}/adminapp:latest"
    cpu       = 1024
    memory    = 2048
    essential = true
    portMappings = [{
      containerPort = var.container_ports["adminapp"]
    }]
    environment = [{
      name  = "BACKEND_URL"
      value = "http://goapp.${aws_service_discovery_private_dns_namespace.ecs_namespace.name}:${var.container_ports["goapp"]}"
    }]
  }])
}

resource "aws_ecs_service" "adminapp_service" {
  name            = "${var.cluster_name}-adminapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.adminapp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [aws_ecs_service.goapp_service]

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# WEBAPP Task and Service
resource "aws_ecs_task_definition" "webapp_task" {
  family                   = "${var.cluster_name}-webapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "webapp"
    image     = "${var.container_registry}/webapp:latest"
    cpu       = 512
    memory    = 1024
    essential = true
    portMappings = [{
      containerPort = var.container_ports["webapp"]
    }]
    environment = [{
      name  = "BACKEND_URL"
      value = "http://pythonapp.${aws_service_discovery_private_dns_namespace.ecs_namespace.name}:${var.container_ports["pythonapp"]}"
    }]
  }])
}

resource "aws_ecs_service" "webapp_service" {
  name            = "${var.cluster_name}-webapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.webapp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [aws_ecs_service.pythonapp_service]

  network_configuration {
    subnets         = aws_subnet.ecs_subnets[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
