# # VPC
# resource "aws_vpc" "hr_vpc" {
#   cidr_block = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = var.project_name
#   }
# }

# # Public Subnets
# resource "aws_subnet" "public_subnet_1a" {
#   vpc_id                  = aws_vpc.hr_vpc.id
#   cidr_block              = var.cidr_block[0]
#   availability_zone       = var.availability_zone[0]
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "public_subnet_1b" {
#   vpc_id                  = aws_vpc.hr_vpc.id
#   cidr_block              = var.cidr_block[1]
#   availability_zone       = var.availability_zone[1]
#   map_public_ip_on_launch = true
# }

# # Private Subnets (use DIFFERENT CIDR index)
# resource "aws_subnet" "private_subnet_1a" {
#   vpc_id            = aws_vpc.hr_vpc.id
#   cidr_block        = var.cidr_block[2]
#   availability_zone = var.availability_zone[0]
# }

# resource "aws_subnet" "private_subnet_1b" {
#   vpc_id            = aws_vpc.hr_vpc.id
#   cidr_block        = var.cidr_block[3]
#   availability_zone = var.availability_zone[1]
# }

# # Internet Gateway
# resource "aws_internet_gateway" "hr_igw" {
#   vpc_id = aws_vpc.hr_vpc.id
# }

# # Elastic IP for NAT
# resource "aws_eip" "hr_eip" {
#   domain = "vpc"
# }

# # NAT Gateway (must be in public subnet)
# resource "aws_nat_gateway" "hr_nat" {
#   allocation_id = aws_eip.hr_eip.id
#   subnet_id     = aws_subnet.public_subnet_1a.id
#   depends_on = [aws_internet_gateway.hr_igw]
# }

# # Public Route Table
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.hr_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.hr_igw.id
#   }
# }

# # Private Route Table
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.hr_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.hr_nat.id
#   }
# }

# # Public Associations
# resource "aws_route_table_association" "public_assoc" {
#   for_each = {
#     subnet_1a = aws_subnet.public_subnet_1a.id
#     subnet_1b = aws_subnet.public_subnet_1b.id
#   }

#   subnet_id      = each.value
#   route_table_id = aws_route_table.public_rt.id
# }

# # Private Associations (FIXED NAME)
# resource "aws_route_table_association" "private_assoc" {
#   for_each = {
#     subnet_1a = aws_subnet.private_subnet_1a.id
#     subnet_1b = aws_subnet.private_subnet_1b.id
#   }

#   subnet_id      = each.value
#   route_table_id = aws_route_table.private_rt.id
# }

# --------------------------------------------------------------------------------------------------

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "3tier-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# DB Subnets
resource "aws_subnet" "db" {
  count = length(var.db_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "db-subnet-${count.index}"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate Private + DB Subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  count = length(var.db_subnets)

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private.id
}