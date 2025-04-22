output "ecr_repository_url" {
  value = aws_ecr_repository.strapi_repo.repository_url
  description = "URL of the ECR repository for your script to push to"
}

output "alb_url" {
  description = "Public URL of the Application Load Balancer"
  value       = aws_lb.strapi_alb.dns_name
}
