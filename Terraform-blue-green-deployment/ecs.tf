
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

# ECS Service
resource "aws_ecs_service" "strapi_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  
  # Use capacity provider strategy for Fargate Spot
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  network_configuration {
    subnets          = aws_subnet.strapi_public_subnet[*].id
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  # Connect to the blue target group initially
  load_balancer {
    target_group_arn = aws_lb_target_group.blue_tg.arn
    container_name   = "strapi-app"
    container_port   = 1337
  }
  
  # Set deployment controller to CODE_DEPLOY for blue/green deployments
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # This will ensure proper ordering of resource creation/deletion
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [task_definition, load_balancer]
  }

  depends_on = [
    aws_lb_listener.strapi_listener_prod
  ]
}
