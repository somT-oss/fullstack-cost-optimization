resource "aws_vpc" "books_vpc" {
  cidr_block = var.vpc_cidr_block_ip

  tags = {
    Name = "books_vpc"
  }
}

resource "aws_subnet" "books_public_subnet" {
  for_each                = var.books_public_subnet
  vpc_id                  = aws_vpc.books_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true


  tags = {
    Name = "books_public_subnet-${each.key}"
  }
  depends_on = [aws_vpc.books_vpc]
}


resource "aws_subnet" "books_private_subnet" {
  for_each          = var.books_private_subnet
  vpc_id            = aws_vpc.books_vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "books_private_subnet-${each.key}"
  }
  depends_on = [aws_vpc.books_vpc]
}


resource "aws_internet_gateway" "books_ig" {
  vpc_id = aws_vpc.books_vpc.id

  tags = {
    Name = "books_ig"
  }
}

resource "aws_route_table" "books_rt" {
  vpc_id = aws_vpc.books_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.books_ig.id
  }

  tags = {
    Name = "books_rt"
  }
}

resource "aws_route_table_association" "books_rta" {
  subnet_id      = values(aws_subnet.books_public_subnet)[0].id
  route_table_id = aws_route_table.books_rt.id
}

resource "aws_security_group" "books_elb_sg" {
  name   = var.books_elb_sg_name
  vpc_id = aws_vpc.books_vpc.id

  # Allow HTTP connections to port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "books_elb_sg"
  }
  depends_on = [aws_vpc.books_vpc]
}

resource "aws_security_group" "books_ec2_sg" {
  # Accepts traffic from the security group of the elb

  name   = var.books_ec2_sg_name
  vpc_id = aws_vpc.books_vpc.id

  # Allow HTTP connections to port 80
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.books_elb_sg.id]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "books_ec2_sg"
  }
  depends_on = [aws_vpc.books_vpc]
}

resource "aws_security_group" "books_rds_sg" {
  # Allows traffic from the security group of the private ec2 instance

  name   = var.books_rds_sg_name
  vpc_id = aws_vpc.books_vpc.id

  # Allow HTTP connections to port 80
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.books_ec2_sg.id]
  }


  egress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "books_rds_sg"
  }
  depends_on = [aws_vpc.books_vpc]
}


