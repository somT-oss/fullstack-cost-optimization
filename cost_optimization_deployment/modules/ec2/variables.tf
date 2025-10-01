variable "instance_name" {
  description = "The name of the EC2 instance."
  type        = string
}

variable "ami" {
  description = "The AMI to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to place the EC2 instance in."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance."
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to attach to the EC2 instance."
  type        = string
  default     = null
}

variable "is_private" {
  description = "Whether this is a private instance."
  type        = bool
  default     = false
}