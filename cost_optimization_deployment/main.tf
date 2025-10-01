
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "nat" {
  source = "./modules/nat"
  public_subnet_id = module.vpc.public_subnet_1_id
}

module "iam" {
  source = "./modules/iam"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat.nat_gateway_id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = module.vpc.private_subnet_1_id
  route_table_id = module.vpc.private_route_table_id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = module.vpc.private_subnet_2_id
  route_table_id = module.vpc.private_route_table_id
}

module "ec2_server" {
  source = "./modules/ec2"

  instance_name = "ec2-server"
  ami           = "ami-0360c520857e3138f" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_1_id 
  vpc_id        = module.vpc.vpc_id
  key_name      = "private-instance-kp"
  is_private    = true
  iam_instance_profile_name = module.iam.ssm_instance_profile_name
}

module "ec2_database_instance" {
  source = "./modules/ec2"

  instance_name = "ec2-database-instance"
  ami           = "ami-0360c520857e3138f" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_2_id
  vpc_id        = module.vpc.vpc_id
  key_name      = "private-instance-kp"
  is_private    = true
  iam_instance_profile_name = module.iam.ssm_instance_profile_name
}

module "ec2_bastion" {
  source = "./modules/ec2"

  instance_name = "ec2-bastion"
  ami           = "ami-0360c520857e3138f" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_1_id
  vpc_id        = module.vpc.vpc_id
}

resource "aws_security_group_rule" "allow_ssh_to_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ec2_bastion.security_group_id
}

resource "aws_security_group_rule" "allow_bastion_to_server" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.ec2_bastion.security_group_id
  security_group_id = module.ec2_server.security_group_id
}

resource "aws_security_group_rule" "allow_server_to_db" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = module.ec2_server.security_group_id
  security_group_id = module.ec2_database_instance.security_group_id
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_alb_to_server" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id = module.ec2_server.security_group_id
}

module "alb" {
  source = "./modules/alb"

  alb_name          = "my-alb"
  security_groups   = [aws_security_group.alb_sg.id]
  subnets           = [module.vpc.public_subnet_2_id, module.vpc.private_subnet_1_id]
  target_group_name = "my-target-group"
  vpc_id            = module.vpc.vpc_id
  instance_id       = module.ec2_server.instance_id
}

