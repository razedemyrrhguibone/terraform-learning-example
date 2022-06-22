# This is where your input variables are declared and created
variable "region_name" {
  type        = string
  default     = "eu-west-2"
  description = "The region name on where the services are created"
}

variable "cluster_name" {
  type        = string
  description = "The name of your ECS Cluster"
}

variable "key_name" {
  type        = string
  description = "The key name of your EC2 Key Pair"
}
