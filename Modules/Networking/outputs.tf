##networking2##
output "vpc" {
    value = aws_vpc.week22vpc.id
}

output "public_subnet_id" {
    value = [aws_subnet.web-subnet[0].id, aws_subnet.web-subnet[1].id]
}

output "private_subnet_id" {
    value = [aws_subnet.application-subnet[0].id, aws_subnet.application-subnet[1].id]
}
    
output "database_subnet_id" {
    value = [aws_subnet.database-subnet[0].id, aws_subnet.database-subnet[1].id]
}