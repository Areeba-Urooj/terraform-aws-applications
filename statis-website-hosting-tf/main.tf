terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-north-1"
}
resource "aws_s3_bucket" "webserver-bucket" {
  bucket = "webserver-bucket-${random_id.rand-s3-bucket-id.hex}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.webserver-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "webserver" {
  bucket = aws_s3_bucket.webserver-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.webserver-bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "webserver" {
  bucket = aws_s3_bucket.webserver-bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.webserver-bucket.bucket
  source = "./index.html"
  key = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.webserver-bucket.bucket
  source = "./style.css"
  key = "style.css"
  content_type = "text/css"
}

resource "random_id" "rand-s3-bucket-id" {
  byte_length = 8
}

output "s3_bucket_id" {
  value = aws_s3_bucket_website_configuration.webserver-bucket.website_endpoint
}