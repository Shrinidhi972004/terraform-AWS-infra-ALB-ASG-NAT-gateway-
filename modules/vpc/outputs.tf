output "vpc_id" {
    description = "ID of the created VPC"
    value = aws_vpc.this.id
}

output "public_subnet_az1_id" {
    description = "ID of the created subnet"
    value = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
    description = "ID of the created subnet"
    value = aws_subnet.public_az2.id
}

output "private_subnet_az1_id" {
  description = "Private subnet ID in AZ1"
  value = aws_subnet.private_az1.id
}

output "private_subnet_az2_id" {
  description = "Private subnet ID in AZ2"
  value = aws_subnet.private_az2.id
}