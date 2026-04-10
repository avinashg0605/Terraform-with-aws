# VPC
resource "aws_vpc" "hr_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.project_name
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.hr_vpc.id
  cidr_block              = var.cidr_block[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.hr_vpc.id
  cidr_block              = var.cidr_block[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true
}

# Private Subnets (use DIFFERENT CIDR index)
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.hr_vpc.id
  cidr_block        = var.cidr_block[2]
  availability_zone = var.availability_zone[0]
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.hr_vpc.id
  cidr_block        = var.cidr_block[3]
  availability_zone = var.availability_zone[1]
}

# Internet Gateway
resource "aws_internet_gateway" "hr_igw" {
  vpc_id = aws_vpc.hr_vpc.id
}

# Elastic IP for NAT
resource "aws_eip" "hr_eip" {
  domain = "vpc"
}

# NAT Gateway (must be in public subnet)
resource "aws_nat_gateway" "hr_nat" {
  allocation_id = aws_eip.hr_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  depends_on = [aws_internet_gateway.hr_igw]
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hr_igw.id
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.hr_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hr_nat.id
  }
}

# Public Associations
resource "aws_route_table_association" "public_assoc" {
  for_each = {
    subnet_1a = aws_subnet.public_subnet_1a.id
    subnet_1b = aws_subnet.public_subnet_1b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

# Private Associations (FIXED NAME)
resource "aws_route_table_association" "private_assoc" {
  for_each = {
    subnet_1a = aws_subnet.private_subnet_1a.id
    subnet_1b = aws_subnet.private_subnet_1b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}