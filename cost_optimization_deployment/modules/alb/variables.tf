variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "security_groups" {
  description = "The security groups to associate with the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets to deploy the ALB in"
  type        = list(string)
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "instance_id" {
  description = "The ID of the EC2 instance to attach to the target group"
  type        = string
}
