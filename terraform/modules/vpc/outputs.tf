output "main_vpc_id" {
    value = aws_vpc.main_vpc.id
}

output "public_subnets_ids"{
    value = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
    ]
}

output "private_subnets_ids"{
    value = [
        aws_subnet.private_subnet_1.id,
        aws_subnet.private_subnet_2.id
    ]
}

output "public_security_group_id" {
    value = aws_security_group.public_security_group.id
}

output "private_security_group_id" {
    value = aws_security_group.private_security_group.id
}