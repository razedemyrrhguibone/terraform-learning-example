# EC2 Role for ECS
data "aws_iam_policy_document" "tflearning-ec2-iam-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tflearning-ec2-iam-role" {
  name               = "tflearning-ec2-iam-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tflearning-ec2-iam-policy-document.json
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_iam_instance_profile" "tflearning-iam-instance-profile" {
  role = aws_iam_role.tflearning-ec2-iam-role.name
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_iam_role_policy_attachment" "tflearning-ec2-iam-role-policy-attachment" {
  role       = aws_iam_role.tflearning-ec2-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# ECS Task Role
data "aws_iam_policy_document" "tflearning-ecs-iam-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tflearning-ecs-iam-role" {
  name               = "tflearning-ecs-iam-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tflearning-ecs-iam-policy-document.json
}

resource "aws_iam_role_policy_attachment" "tflearning-ecs-iam-role-policy-attachment" {
  role       = aws_iam_role.tflearning-ecs-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
