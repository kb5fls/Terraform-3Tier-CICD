# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.project_name}-vpc"
    Owner = "Salem"
  }
}

# Create Internet gateway and attach it to VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.project_name}-igw"
    Owner = "Salem"
  }
}

# Use data source to get all availabiity zones in region
data "aws_availability_zone" "available_zones" {}

# Create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zone.available_zones.name[0]
  map_public_ip_on_launch = true

  tags = {
    Name  = "public_subnet_az1"
    Owner = "Salem"
  }
}

# Create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zone.available_zones.name[1]

  tags = {
    Name  = "public_subnet_az2"
    Owner = "Salem"
  }
}

# Create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name  = "public_route_table"
    Owner = "Salem"
  }
}

# Associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zone.available_zones.name[0]
  map_public_ip_on_launch = false

  tags = {
    Name  = "private app subnet az1"
    Owner = "Salem"
  }
}

# Create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zone.available_zones.name[1]

  tags = {
    Name  = "private app subnet az2"
    Owner = "Salem"
  }
}

# Create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_subnet_az1_cidr
  availability_zone       = data.aws_availability_zone.available_zones.name[0]
  map_public_ip_on_launch = false

  tags = {
    Name  = "private data subnet az1"
    Owner = "Salem"
  }
}

# Create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_data_subnet_az2_cidr
  availability_zone = data.aws_availability_zone.available_zones.name[1]

  tags = {
    Name  = "Private data subnet az2"
    Owner = "Salem"
  }
}

