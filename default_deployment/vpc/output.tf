output "books_ec2_sg_id" {
    value = aws_security_group.books_ec2_sg.id
}

output "private_subnet_id" {
  value = [for s in aws_subnet.books_private_subnet : s.id][0]
}

output "private_subnets" {
  value = [for s in aws_subnet.books_private_subnet : s.id]
}

output "rds_sg_id" {
  value = aws_security_group.books_rds_sg.id
}