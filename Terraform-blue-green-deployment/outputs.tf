# output "ecr_repository_url" {
#   value = aws_ecr_repository.strapi_repo.repository_url
#   description = "URL of the ECR repository for your script to push to"
# }

output "alb_dns_name" {
  value       = aws_lb.strapi_alb.dns_name
  description = "The DNS name of the Application Load Balancer"
}