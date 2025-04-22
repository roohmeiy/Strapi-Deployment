# Fetch available AZs
data "aws_availability_zones" "available" {}

# Reference the ECR repository created by the ECR module
data "aws_ecr_repository" "strapi_repo" {
  name = var.ecr_repo_name
}

# Create a VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

# Create public subnets in 2 AZs
resource "aws_subnet" "strapi_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.strapi_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "strapi-public-subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# Route Table
resource "aws_route_table" "strapi_route_table" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "strapi_association" {
  count          = 2
  subnet_id      = aws_subnet.strapi_public_subnet[count.index].id
  route_table_id = aws_route_table.strapi_route_table.id
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group
resource "aws_security_group" "strapi_sg" {
  vpc_id = aws_vpc.strapi_vpc.id

  # Allow incoming traffic on port 1337 (Strapi)
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow incoming traffic on port 80 (ALB)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster" {
  name = var.ecs_cluster_name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = var.task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "strapi-app"
    image     = "${data.aws_ecr_repository.strapi_repo.repository_url}:${var.image_tag}"
    cpu       = 256
    memory    = 512
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

# Load Balancer
resource "aws_lb" "strapi_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.strapi_sg.id]
  subnets            = aws_subnet.strapi_public_subnet[*].id
  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

# Target Group with IP target type for Fargate
resource "aws_lb_target_group" "strapi_tg" {
  name        = var.target_group_name
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.strapi_vpc.id
  target_type = "ip"
  
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"  # Accept a wider range of success codes
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}

# ECS Service
resource "aws_ecs_service" "strapi_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.strapi_public_subnet[*].id
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi-app"
    container_port   = 1337
  }

  depends_on = [
    aws_lb_listener.strapi_listener
  ]

  # This will ensure proper ordering of resource creation/deletion
  lifecycle {
    create_before_destroy = true
  }
}