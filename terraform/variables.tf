variable "aws_region" {
  description = "AWS Region"
  default     = "ap-southeast-5"
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  default     = "devops-test-cluster"
}

variable "container_ports" {
  description = "Ports for each application"
  default     = {
    goapp     = 8080
    pythonapp = 8090
    webapp    = 3001
    adminapp  = 3000
    traefik   = 80
  }
}

variable "container_registry" {
  default = "202533527371.dkr.ecr.ap-southeast-5.amazonaws.com"
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  sensitive   = true
  default = ""
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  sensitive   = true
  default = ""
}

variable "subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_cidr" { 
  description = "VPC CIDR block" 
  default = "10.0.0.0/16" 
}

