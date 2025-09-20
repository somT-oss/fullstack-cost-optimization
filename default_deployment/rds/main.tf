resource "aws_db_instance" "books_rds_instance" {
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class # "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.db_parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.books_rds_db_sg.name
  vpc_security_group_ids = [var.rds_sg_id]
}

resource "aws_db_subnet_group" "books_rds_db_sg" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets
}