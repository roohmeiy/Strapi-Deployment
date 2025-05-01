
# ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster" {
  name = var.ecs_cluster_name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = var.task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "strapi-app"
    image     = "${data.aws_ecr_repository.strapi_repo.repository_url}:${var.image_tag}"
    cpu       = 1024
    memory    = 2048
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "API_TOKEN_SALT"
        value = var.api_token_salt
      },
      {
        name  = "ADMIN_JWT_SECRET"
        value = var.admin_jwt_secret
      },
      {
        name  = "TRANSFER_TOKEN_SALT"
        value = var.transfer_token_salt
      },
      {
        name  = "APP_KEYS"
        value = var.app_keys
      }
    ]
  }])
}
