# Load Balancer
resource "aws_security_group" "tflearning-load-balancer-security-group" {
  name        = "tflearning-load-balancer-security-group"
  description = "Load Balancer Security Group"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

# Allow All
resource "aws_security_group" "tflearning-allow-all-security-group" {
  name        = "tflearning-allow-all-security-group"
  description = "Allow All Security Group"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}
