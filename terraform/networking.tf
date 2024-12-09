data "aws_availability_zones" "available" {}

resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
   Name = "Test-VPC"
 }
}

resource "aws_subnet" "ecs_subnets" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "main" { 
  vpc_id = aws_vpc.ecs_vpc.id 
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidrs)
  subnet_id      = element(aws_subnet.ecs_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}


output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.ecs_subnets[*].id
}