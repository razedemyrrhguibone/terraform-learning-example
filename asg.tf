resource "aws_launch_configuration" "tflearning-launch-configuration" {
  name          = "tflearning-launch-configuration"
  image_id      = data.aws_ami.tflearning-ami-amazon.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile        = aws_iam_instance_profile.tflearning-iam-instance-profile.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.tflearning-allow-all-security-group.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "tflearning-autoscaling-group" {
  name                      = "tflearning-autoscaling-group"
  launch_configuration      = aws_launch_configuration.tflearning-launch-configuration.name
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = module.vpc.public_subnets
  target_group_arns         = [aws_lb_target_group.tflearning-lb-target-group.arn]
  protect_from_scale_in     = true
  lifecycle {
    create_before_destroy = true
  }
}
