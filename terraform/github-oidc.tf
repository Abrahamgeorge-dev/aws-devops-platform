# Identify the AWS account running this Terraform configuration.
data "aws_caller_identity" "current" {}

# Allow GitHub Actions to identify itself to AWS through OIDC.
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name    = "aws-devops-platform-github-oidc"
    Project = "aws-devops-platform"
  }
}

# Trust only the main branch of the specified GitHub repository.
resource "aws_iam_role" "github_actions" {
  name = "aws-devops-platform-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:Abrahamgeorge-dev@292764757/aws-devops-platform@1409076955:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name    = "aws-devops-platform-github-actions-role"
    Project = "aws-devops-platform"
  }
}

# Allow this role to push images to this project's ECR repository.
resource "aws_iam_role_policy" "github_actions_ecr_push" {
  name = "aws-devops-platform-ecr-push"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:DescribeImages"
        ]

        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}

# Allow GitHub Actions to send and inspect deployment commands through SSM.
resource "aws_iam_role_policy" "github_actions_ssm_deploy" {
  name = "aws-devops-platform-ssm-deploy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:SendCommand"
        ]

        Resource = [
          "arn:aws:ssm:eu-west-2::document/AWS-RunShellScript",
          "arn:aws:ec2:eu-west-2:106062678657:instance/i-040abac569953b65f"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations"
        ]

        Resource = "*"
      }
    ]
  })
}
