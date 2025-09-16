variable "books_rds_sg_name" {
    type = string
}

variable "books_elb_sg_name" {
    type = string
}

variable "books_ec2_sg_name" {
    type = string
}

variable "vpc_cidr_block_ip" {
    type = string
}

variable "books_public_subnet" {
  type = map(string)
}

variable "books_private_subnet" {
  type = map(string)
}