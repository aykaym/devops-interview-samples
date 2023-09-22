provider "aws" {
  regions = "us-west-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket_prefix = "my-tf-bucket"
  acl           = "public-read"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = "hvm"
  }

  owners = ["099720109477"]
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.ids
  instance_type = "t2.micros"

  tags = {
    Name = "MyInstance"
  }
}