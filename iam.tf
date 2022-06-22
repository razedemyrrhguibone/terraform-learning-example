# EC2 Role for ECS
resource "aws_iam_role" "tflearning-ec2-iam-role" {
  name = "tflearning-ec2-iam-role"
  path = "/"
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
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
