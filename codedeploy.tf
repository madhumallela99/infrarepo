############################################
# CodeDeploy Application
############################################

resource "aws_codedeploy_app" "eks_app" {
  name             = "springboot-eks-app"
  compute_platform = "Server"
}

############################################
# CodeDeploy Deployment Group
############################################

resource "aws_codedeploy_deployment_group" "eks_dg" {

  app_name              = aws_codedeploy_app.eks_app.name
  deployment_group_name = "springboot-dg"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
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
}
