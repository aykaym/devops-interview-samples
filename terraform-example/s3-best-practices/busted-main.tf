provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-unique-bucket"
  acl    = "public-read-write"
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3FullAccessPolicy"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = "arn:aws:s3:::my-tf-unique-bucket/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "0.0.0.0/0"
          }
        }
      }
    ]
  })
}

# The goal is to modify the S3 bucket to:

# Have server-side encryption enabled.
# Not allow public read access.
# Only allow access from certain IP ranges.