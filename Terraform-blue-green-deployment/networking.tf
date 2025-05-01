# Fetch available AZs
data "aws_availability_zones" "available" {}

# Reference the ECR repository created by the ECR module
data "aws_ecr_repository" "strapi_repo" {
  name = var.ecr_repo_name
}

# Create a VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

# Create public subnets in 2 AZs
resource "aws_subnet" "strapi_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.strapi_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "strapi-public-subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# Route Table
resource "aws_route_table" "strapi_route_table" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "strapi_association" {
  count          = 2
  subnet_id      = aws_subnet.strapi_public_subnet[count.index].id
  route_table_id = aws_route_table.strapi_route_table.id
}

# Security Group
resource "aws_security_group" "strapi_sg" {
  vpc_id = aws_vpc.strapi_vpc.id

  # Allow incoming traffic on port 1337 (Strapi)
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow incoming traffic on port 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow incoming traffic on port 443 (HTTPS)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
