provider "aws" {
  region = "us-west-2"
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "my-tf-test-bucket"
}

module "rds_instance" {
  source         = "./modules/rds"
  instance_class = "db.t2.micro"
  db_name        = "mydb"
  username       = "foo"
  password       = "foobarbaz"
}