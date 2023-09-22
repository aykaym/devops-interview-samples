provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-unique-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3LimitedAccessPolicy"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"]
        Resource  = "arn:aws:s3:::my-tf-unique-bucket/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["192.168.1.0/24", "10.10.0.0/16"]
          }
        }
      }
    ]
  })
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# The goal is to modify the S3 bucket to:

# Have server-side encryption enabled.
# Not allow public read access.
# Only allow access from certain IP ranges.