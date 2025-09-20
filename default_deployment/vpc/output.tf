output "books_ec2_sg_id" {
  value = aws_security_group.books_ec2_sg.id
}

output "private_subnets_id" {
  value = [for s in aws_subnet.books_private_subnet : s.id][0]
}

output "private_subnets" {
  value = { for k, s in aws_subnet.books_private_subnet : k => s.id }
}

output "private_subnet_list" {
 value = [for s in aws_subnet.books_private_subnet : s.id]
}
output "rds_sg_id" {
  value = aws_security_group.books_rds_sg.id
}

output "public_subnet_id" {
  value = values(aws_subnet.books_public_subnet)[0].id
}

output "vpc_id" {
  value = aws_vpc.books_vpc.id
}