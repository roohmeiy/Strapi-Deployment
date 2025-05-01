# CodeDeploy Application
resource "aws_codedeploy_app" "strapi_app" {
  name             = var.codedeploy_app_name
  compute_platform = "ECS"
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "strapi_deployment_group" {
  app_name               = aws_codedeploy_app.strapi_app.name
  deployment_group_name  = var.codedeploy_deployment_group_name
  deployment_config_name = var.deployment_config_name
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.strapi_service.name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.strapi_listener_prod.arn]
      }

      test_traffic_route {
        listener_arns = [aws_lb_listener.strapi_listener_test.arn]
      }

      target_group {
        name = aws_lb_target_group.blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.green_tg.name
      }
    }
  }
}

