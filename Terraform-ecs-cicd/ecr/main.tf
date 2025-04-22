provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "strapi_repo" {
  name = var.ecr_repo_name
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
    Name = "strapi-app-repository"
  }

  # This will make terraform not fail if the repository already exists
  lifecycle {
    ignore_changes = [
      image_scanning_configuration,
      image_tag_mutability
    ]
  }
}