variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "repo_uri" {
  description = "URI of the existing ECR repository"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

# variable "ecr_repo_name" {
#   description = "The name of the ECR Repository"
#   type        = string
# }

variable "task_definition_name" {
  description = "The name of the ECS Task Definition"
  type        = string
}

variable "security_group_name" {
  description = "The name of the Security Group"
  type        = string
}

variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "The name of the Load Balancer Target Group"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS Service"
  type        = string
}

variable "api_token_salt" {
  description = "API Token Salt"
  type        = string
}

variable "admin_jwt_secret" {
  description = "Admin JWT Secret"
  type        = string
}

variable "transfer_token_salt" {
  description = "Transfer Token Salt"
  type        = string
}

variable "app_keys" {
  description = "App Keys"
  type        = string
}

