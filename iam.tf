############################################
# IAM Role for AWS CodeDeploy (EKS)
############################################

resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployEKSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

############################################
# Custom IAM Policy for CodeDeploy + EKS
############################################

resource "aws_iam_policy" "codedeploy_eks_policy" {
  name        = "CodeDeployEKSBasicPolicy"
  description = "IAM policy for CodeDeploy to deploy applications to EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Allow describing EKS cluster
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      },

      # Allow ELB / ALB operations for traffic shifting
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      },

      # Allow EC2 + ASG interactions
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "autoscaling:*"
        ]
        Resource = "*"
      },

      # Allow CloudWatch for deployment monitoring
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:*"
        ]
        Resource = "*"
      }
    ]
  })
}

############################################
# Attach Custom Policy to CodeDeploy Role
############################################

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_eks_policy.arn
}
