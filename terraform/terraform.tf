terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }

  # This adds backend terraform state to s3 bucket
  backend "s3" {
    bucket               = "pantheon-terraform-remote-backend-state-kl"
    key                  = "dev/ecs/terraform.tfstate"
    region               = "ap-southeast-5"
    skip_region_validation = true
  }
}