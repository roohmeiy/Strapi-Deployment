output "alb_url" {
  description = "Public URL of the Application Load Balancer"
  value       = aws_lb.strapi_alb.dns_name
}

# output "ecr_repository_url" {
#   description = "ECR Repository URL"
#   value       = aws_ecr_repository.strapi_repo.repository_url
# }