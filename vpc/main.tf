terraform {
  backend "s3" {}
}

resource "aws_vpc" "main" {
	cidr_block = var.cidr_block
	tags = {
		Name = var.name
	}
}

# Data source for availability zones
data "aws_availability_zones" "available" {
	state = "available"
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
	vpc_id = aws_vpc.main.id
	tags = {
		Name = "${var.name}-igw"
	}
}

# Public Subnets
resource "aws_subnet" "public" {
	count             = var.public_subnet_count
	vpc_id            = aws_vpc.main.id
	cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
	availability_zone = data.aws_availability_zones.available.names[count.index]
				  
	map_public_ip_on_launch = true
				  
	tags = {
		Name = "${var.name}-public-${count.index + 1}"
		Type = "Public"
	}
}

# Private Subnets
resource "aws_subnet" "private" {
	count             = var.private_subnet_count
	vpc_id            = aws_vpc.main.id
	cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + var.public_subnet_count)
	availability_zone = data.aws_availability_zones.available.names[count.index]
				  
	tags = {
		Name = "${var.name}-private-${count.index + 1}"
		Type = "Private"
	}
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
	count  = var.enable_nat_gateway ? var.public_subnet_count : 0
	domain = "vpc"
				  
	tags = {
		Name = "${var.name}-nat-eip-${count.index + 1}"
	}
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
	count         = var.enable_nat_gateway ? var.public_subnet_count : 0
	allocation_id = aws_eip.nat[count.index].id
	subnet_id     = aws_subnet.public[count.index].id
				  
	tags = {
		Name = "${var.name}-nat-${count.index + 1}"
	}
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id
				  
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.main.id
	}
				  
	tags = {
		Name = "${var.name}-public-rt"
	}
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
	count  = var.enable_nat_gateway ? var.private_subnet_count : 0
	vpc_id = aws_vpc.main.id
				  
	route {
		cidr_block     = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.main[count.index].id
	}
				  
	tags = {
		Name = "${var.name}-private-rt-${count.index + 1}"
	}
}
