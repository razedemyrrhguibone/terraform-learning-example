data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 3.0"
  name            = "tflearning-vpc"
  cidr            = "10.0.0.0/16"
  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.201.0/24"]
  tags = {
    name      = "tflearning"
    env       = "development"
    createdBy = "sky"
  }
}

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}
