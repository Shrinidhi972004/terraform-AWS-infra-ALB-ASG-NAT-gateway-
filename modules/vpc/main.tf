resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true 
    enable_dns_support = true
    tags = {
        Name = "${var.environment}-vpc"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.environment}-igw"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_subnet" "public_az1" {
    vpc_id = aws_vpc.this.id
    cidr_block =var.public_subnet_cidr_az1
    availability_zone = var.az1
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.environment}-public-subnet-az1"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_subnet" "public_az2" {
    vpc_id = aws_vpc.this.id
    cidr_block =var.public_subnet_cidr_az2
    availability_zone = var.az2
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.environment}-public-subnet-az2"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_subnet" "private_az1" {
    vpc_id = aws_vpc.this.id
    cidr_block =var.private_subnet_cidr_az1
    availability_zone = var.az1
    map_public_ip_on_launch = false
    tags = {
        Name = "${var.environment}-private-subnet-az1"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_subnet" "private_az2" {
    vpc_id = aws_vpc.this.id
    cidr_block =var.private_subnet_cidr_az2
    availability_zone = var.az2
    map_public_ip_on_launch = false
    tags = {
        Name = "${var.environment}-private-subnet-az2"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_eip" "nat_az1" {
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-eip-nat-az1"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_eip" "nat_az2" {
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-eip-nat-az2"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_nat_gateway" "az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name        = "${var.environment}-nat-az1"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_nat_gateway" "az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id

  tags = {
    Name        = "${var.environment}-nat-az2"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    route { 
        cidr_block = "0.0.0.0/0"
        gateway_id =aws_internet_gateway.this.id
    }
    tags = {
        Name = "${var.environment}-public-rt"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1.id
  }

  tags = {
    Name        = "${var.environment}-private-rt-az1"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az2.id
  }

  tags = {
    Name        = "${var.environment}-private-rt-az2"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_az1.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_az2.id
}

