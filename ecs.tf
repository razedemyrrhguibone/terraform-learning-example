resource "aws_ecs_capacity_provider" "tflearning-ecs-capacity-provider" {
  name = "tflearning-ecs-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.tflearning-autoscaling-group.arn
    managed_termination_protection = "ENABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 2
    }
  }

  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_ecs_cluster" "tflearning-ecs-cluster" {
  name = var.cluster_name
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_ecs_cluster_capacity_providers" "tflearning-ecs-cluster-capacity-providers" {
  cluster_name       = aws_ecs_cluster.tflearning-ecs-cluster.name
  capacity_providers = [aws_ecs_capacity_provider.tflearning-ecs-capacity-provider.name]
}

data "template_file" "tflearning-container-definitions" {
  template = file("definitions/container-definitions.json")
}

resource "aws_ecs_task_definition" "tflearning-ecs-task-definition" {
  family                = "tflearning-ecs-task-definition"
  container_definitions = data.template_file.tflearning-container-definitions.rendered
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.tflearning-ecs-iam-role.arn
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_ecs_service" "tflearning-ecs-service" {
  name            = "tflearning-ecs-service"
  cluster         = aws_ecs_cluster.tflearning-ecs-cluster.id
  task_definition = aws_ecs_task_definition.tflearning-ecs-task-definition.arn
  desired_count   = 1
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tflearning-lb-target-group.arn
    container_name   = "tflearning"
    container_port   = 80
  }

  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "EC2"
  depends_on  = [aws_lb_listener.tflearning-lb-listener]
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

resource "aws_cloudwatch_log_group" "tflearning-cloudwatch-log-group" {
  name = "/ecs/${var.cluster_name}"
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}
