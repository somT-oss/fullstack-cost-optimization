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

variable "private_subnets" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "rds_sg_id" {
  type = string
}

