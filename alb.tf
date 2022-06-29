resource "aws_lb" "tflearning-lb" {
  name               = "tflearning-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.tflearning-load-balancer-security-group.id]
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_lb_target_group" "tflearning-lb-target-group" {
  name        = "tflearning-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.main.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }

  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_lb_listener" "tflearning-lb-listener" {
  load_balancer_arn = aws_lb.tflearning-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tflearning-lb-target-group.arn
  }

  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}
