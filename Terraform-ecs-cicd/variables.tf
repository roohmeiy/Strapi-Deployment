variable "aws_region" {
  description = "The AWS region to deploy to"
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

# variable "create_ecr_repo" {
#   description = "Whether to create a new ECR repository"
#   type        = bool
#   default     = true
# }

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
variable "image_tag" {
  description = "Tag of the Docker image to deploy"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "Name for CloudWatch log group"
  type        = string
  default     = "/ecs/strapi"
}

variable "ecs_task_execution_role_name" {
  description = "Name for ECS task execution IAM role"
  type        = string
  default     = "payalStrapiEcsTaskExecutionRole"
}

variable "cloudwatch_policy_name" {
  description = "Name for CloudWatch IAM policy"
  type        = string
  default     = "payal-strapi-cloudwatch-policy"
}

variable "cpu_alarm_name" {
  description = "Name for CPU utilization alarm"
  type        = string
  default     = "payal-strapi-cpu-utilization-high"
}

variable "memory_alarm_name" {
  description = "Name for memory utilization alarm"
  type        = string
  default     = "payal-strapi-memory-utilization-high"
}

variable "response_time_alarm_name" {
  description = "Name for ALB response time alarm"
  type        = string
  default     = "payal-strapi-alb-high-response-time"
}

variable "error_5xx_alarm_name" {
  description = "Name for ALB 5XX error alarm"
  type        = string
  default     = "payal-strapi-alb-high-5xx-error"
}

variable "dashboard_name" {
  description = "Name for CloudWatch dashboard"
  type        = string
  default     = "payal-strapi-monitoring-dashboard"
}