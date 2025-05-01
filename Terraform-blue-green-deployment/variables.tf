variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default = "payal-strapi-vpc"
}

variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
  default = "payal-strapi-igw"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default = "payal-strapi-ecs-cluster"
}

variable "task_definition_name" {
  description = "The name of the ECS Task Definition"
  type        = string
  default = "payal-strapi-taskdef"
}

variable "security_group_name" {
  description = "The name of the Security Group"
  type        = string
  default = "payal-strapi-sg"
}

variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
  default = "payal-strapi-alb"
}

variable "target_group_name" {
  description = "The name of the Load Balancer Target Group"
  type        = string
  default = "payal-strapi-alb"
}

variable "ecs_service_name" {
  description = "The name of the ECS Service"
  type        = string
  default = "payal-strapi-ecs-service"
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

# variable "create_ecr_repo" {
#   description = "Whether to create a new ECR repository"
#   type        = bool
#   default     = true
# }

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default = "payal-strapi-app"
}
variable "image_tag" {
  description = "Tag of the Docker image to deploy"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "Name for ECS task execution IAM role"
  type        = string
  default     = "payalStrapiEcsTaskExecutionRole"
}

variable "codedeploy_app_name" {
  description = "Name of the CodeDeploy application"
  type        = string
  default = "payal-strapi-codedeploy_app_name"
}

variable "codedeploy_deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
  default = "payal-strapi-codedeploy_deployment_group"
}

variable "deployment_config_name" {
  description = "Deployment config for CodeDeploy (e.g., CodeDeployDefault.ECSCanary10Percent5Minutes)"
  type        = string
  default = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}

