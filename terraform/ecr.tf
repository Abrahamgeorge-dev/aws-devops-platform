resource "aws_ecr_repository" "app" {
  name                 = "aws-devops-platform-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "aws-devops-platform-repo"
  }
}
