resource "aws_eip" "books_nat_gateway_eip" {
#   vpc = true
}

resource "aws_nat_gateway" "books_nat_gateway" {
  allocation_id = aws_eip.books_nat_gateway_eip.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "books_nat_gateway"
  }

  depends_on = [aws_eip.books_nat_gateway_eip]
}

resource "aws_route_table" "books_private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.books_nat_gateway.id
  }

  tags = {
    Name = "books_private_rt"
  }
}

resource "aws_route_table_association" "books_private_rta" {
  for_each       = var.private_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.books_private_rt.id
}