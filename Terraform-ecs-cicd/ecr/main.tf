# main.tf for ECR module

data "aws_ecr_repository" "existing_repo" {
  count = var.create_repository ? 0 : 1
  name  = var.ecr_repo_name
}

resource "aws_ecr_repository" "strapi_repo" {
  count = var.create_repository ? 1 : 0
  name  = var.ecr_repo_name
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "create_repository" {
  description = "Whether to create a new repository or use existing one"
  type        = bool
  default     = false
}


output "repository_url" {
  description = "The URL of the repository"
  value       = var.create_repository ? aws_ecr_repository.strapi_repo[0].repository_url : data.aws_ecr_repository.existing_repo[0].repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = var.ecr_repo_name
}