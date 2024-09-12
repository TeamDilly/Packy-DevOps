resource "aws_ecr_repository" "packy-v2-dev" {
  name = "packy-v2-dev"
}

resource "aws_ecr_repository" "packy-v2-prod" {
  name = "packy-v2-prod"
}

resource "aws_ecr_repository" "packy-v2-web-dev" {
  name = "packy-v2-web-dev"
}

resource "aws_ecr_lifecycle_policy" "pack_v2_lifecycle" {
  for_each = {
    dev  = aws_ecr_repository.packy-v2-dev.name
    prod = aws_ecr_repository.packy-v2-prod.name
    web-dev = aws_ecr_repository.packy-v2-web-dev.name
  }

  repository = each.value

  policy = <<POLICY
  {
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire old images when there are more than 2",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 2
            },
            "action": {
                "type": "expire"
            }
        }
    ]
  }
  POLICY
}