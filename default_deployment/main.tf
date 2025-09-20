provider "aws" {
  region = var.region
}


module "vpc" {
  source               = "./vpc"
  books_elb_sg_name    = var.books_elb_sg_name
  books_ec2_sg_name    = var.books_ec2_sg_name
  books_rds_sg_name    = var.books_rds_sg_name
  books_private_subnet = var.books_private_subnet
  books_public_subnet  = var.books_public_subnet
  vpc_cidr_block_ip    = var.vpc_cidr_block_ip
}

module "server" {
  source            = "./ec2"
  instance_ami      = var.instance_ami
  instance_type     = var.instance_type
  private_subnet_id = module.vpc.private_subnets_id
  books_ec2_sg_id   = module.vpc.books_ec2_sg_id
}

module "nat_gateway" {
  source             = "./nat_gateway"
  public_subnet_id   = module.vpc.public_subnet_id
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}

module "rds" {
  source = "./rds"
  allocated_storage    = var.allocated_storage
  db_engine               = var.db_engine
  db_name              = var.db_name
  db_engine_version       = var.db_engine_version
  db_instance_class       = var.db_instance_class # "db.t3.micro"
  db_username             = var.db_username
  db_password             = var.db_password
  db_parameter_group_name = var.db_parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name = var.db_subnet_group_name
  private_subnets = module.vpc.private_subnet_list
  rds_sg_id = module.vpc.rds_sg_id
}