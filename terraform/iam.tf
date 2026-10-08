resource "aws_iam_role" "ec2_ecr_pull" {
  name = "aws-devops-platform-ec2-ecr-pull-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "aws-devops-platform-ec2-ecr-pull-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_readonly" {
  role       = aws_iam_role.ec2_ecr_pull.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_ecr_pull" {
  name = "aws-devops-platform-ec2-ecr-pull-profile"
  role = aws_iam_role.ec2_ecr_pull.name
}
