# network.tf
# Creates an isolated VPC with internet access via an Internet Gateway.

# VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true   # Enables DNS resolution for instances
  tags = {
    Name = "k8s-custom-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = {
    Name = "k8s-igw"
  }
}

# Public Subnet (instances get public IP automatically)
resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true   # Assigns a public IP on launch
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "k8s-public-subnet"
  }
}

# Route Table (routes all outbound traffic to the Internet Gateway)
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.k8s_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.rt.id
}
