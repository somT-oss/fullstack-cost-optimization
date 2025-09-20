variable "vpc_cidr_block_ip" {
  type = string
}

variable "books_public_subnet" {
  type = map(string)
}

variable "books_private_subnet" {
  type = map(string)
}

variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "books_ec2_sg_name" {
  type = string
}

variable "books_rds_sg_name" {
  type = string
}

variable "books_elb_sg_name" {
  type = string
}

variable "region" {
  type = string
}

/*

    RDS INSTANCE ENVIRONMENT VARIABLES

*/

variable "allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_parameter_group_name" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "db_subnet_group_name" {
  type = string
}