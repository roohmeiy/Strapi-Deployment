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

# Blue Target Group
resource "aws_lb_target_group" "blue_tg" {
  name        = "${var.target_group_name}-blue"
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

# Green Target Group
resource "aws_lb_target_group" "green_tg" {
  name        = "${var.target_group_name}-green"
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

# Load Balancer Listener - Production
resource "aws_lb_listener" "strapi_listener_prod" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

# Load Balancer Listener - Test (used during deployment)
resource "aws_lb_listener" "strapi_listener_test" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 8080  # Test port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_tg.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}
