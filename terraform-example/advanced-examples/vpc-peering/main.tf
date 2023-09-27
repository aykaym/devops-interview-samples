provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "east_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "east_vpc"
  }
}

resource "aws_subnet" "east_subnet" {
  vpc_id     = aws_vpc.east_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "east_subnet"
  }
}

resource "aws_instance" "east_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI. Make sure to use the latest.
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.east_subnet.id

  tags = {
    Name = "east_instance"
  }
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_vpc" "west_vpc" {
  provider = aws.west

  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "west_vpc"
  }
}

resource "aws_subnet" "west_subnet" {
  provider = aws.west

  vpc_id     = aws_vpc.west_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "west_subnet"
  }
}

resource "aws_instance" "west_instance" {
  provider = aws.west

  ami           = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI. Use the latest for us-west-2 region.
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.west_subnet.id

  tags = {
    Name = "west_instance"
  }
}

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = aws_vpc.west_vpc.id
  vpc_id      = aws_vpc.east_vpc.id
  auto_accept = true

  tags = {
    Name = "east-to-west"
  }
}

resource "aws_route" "east_to_west" {
  route_table_id         = aws_vpc.east_vpc.main_route_table_id
  destination_cidr_block = aws_vpc.west_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "west_to_east" {
  provider = aws.west

  route_table_id         = aws_vpc.west_vpc.main_route_table_id
  destination_cidr_block = aws_vpc.east_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}


#This Terraform script does the following:

# 1. Sets up two VPCs in the respective regions.
# 2. Within each VPC, a subnet and an EC2 instance are created.
# 3. Initiates a VPC peering connection between the two VPCs and automatically accepts it.
# 4. Sets up routing so that the two VPCs can communicate.

# Remember to replace the AMI ids with the latest ones for the respective regions and desired OS.

