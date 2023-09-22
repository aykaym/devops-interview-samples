provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# In this Terraform script:

# A new VPC is created with a CIDR block of 10.0.0.0/16.
# Two subnets are created: a public one (10.0.1.0/24) that has map_public_ip_on_launch set to true, and a private one (10.0.2.0/24).
# An Internet Gateway is associated with the VPC.
# A public route table is created with a route to the internet (0.0.0.0/0) via the Internet Gateway.
# The public subnet is associated with this route table, making it public.
# For more advanced setups, additional configurations (like setting up NAT gateways for private subnets, security groups, NACLs, etc.) would be needed. Always ensure to understand the security implications of the setup, and thoroughly review any Terraform code before applying.




