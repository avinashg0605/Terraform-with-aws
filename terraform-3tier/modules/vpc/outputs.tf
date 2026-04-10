# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.hr_vpc.id
}

# Subnets
output "public_subnets" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1b.id
  ]
}

output "private_subnets" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
  ]
}

# Internet Gateway
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.hr_igw.id
}

# NAT Gateway
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.hr_nat.id
}

# Route Tables
output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}