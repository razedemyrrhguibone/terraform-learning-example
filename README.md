# Provisioning ECS via EC2 infrastructure using Terraform
## Execution Steps to create infrastructure
1. clone
2. cd terraform-learning-example
3. Create an EC2 Key Pair (Optional)
4. terraform init
5. terraform plan
6. terraform apply

## Execution Steps to delete infrastructure
1. Scale down EC2 auto scaling group
2. Terminate EC2 instances
3. Run `terraform destroy`

## Details
`alb.tf` - also known as "Application Load Balancer". This is a load balancer configured for EC2 instances. It consists of 3 main parts:
1. aws_lb - main load balancer configuration.
2. aws_lb_target_group - load balancer security target group using region VPC as subnets.
3. aws_lb_listener - the route request enabled to be recieved by load balancer.

`ami.tf` - also known as "Amazon Machine Images". This is an image configuration for running EC2 instances via launch configuration on autoscaling group.
`asg.tf` - also known as "Autoscaling Group". This enables scale out configuration of EC2 instances and requires the load balancer arn.
Details:
1. `aws_launch_configuration` - resource configuration to launch auto scale for EC2 instances via Load Balancer.
2. `aws_autoscaling_group` - main configuration for auto scaling EC2 instances.

`ecs.tf` - also known as "Elastic Container Service". A service holding out container instances.
Details:
1. `aws_ecs_capacity_provider` - provides scaling of ECS instances.
2. `aws_ecs_cluster` - main resource that holds ECS tasks and instances.
3. `aws_ecs_cluster_capacity_providers` - defines the capacity provider used in the cluster.
4. `aws_ecs_task_definition` - configurations for the containers.
5. `aws_ecs_service` - main resource to run ECS instances.

`iam.tf` - also known as "Identity and Access Management". This provides role accesses for resources.
`main.tf` - declare providers.
`outputs.tf` - get outputs from resources and print it once you run the terraform command.
`security-group.tf` - declare security groups that is required by other resources.
`variables.tf` - setup for input items that can be provided inside terraform execution.
`vpc.tf` - also known as "Virtual Private Cloud". Using a terraform vpc module, creation of private network with high availability can be achieved and be used by other resources that requires it.