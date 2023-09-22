provider "aws" {
  region = "us-west-1"
}

# VPC and related networking resources
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

# RDS Database and security group
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_db_instance" "database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  subnet_group_name      = aws_db_subnet_group.default.name
  monitoring_interval    = 5
  monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id]

  tags = {
    Name = "main"
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# EC2 instance, security group, and IAM role
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow traffic for EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-03cf127a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  key_name      = "my_keypair"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  tags = {
    Name = "WebServer"
  }

  depends_on = [
    aws_db_instance.database
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "my_keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}