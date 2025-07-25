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
resource "aws_s3_bucket" "practice_bucket" {
  bucket = "WebServer_bucket_${random_id.rand_s3-bucket_id.hex}"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.WebServer_bucket.bucket
  source = "./index.html"
  key = "index.html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.WebServer_bucket.bucket
  source = "./style.css"
  key = "style.css"
}

resource "random_id" "rand_s3-bucket_id" {
  byte_length = 8
}

output "s3_bucket_id" {
  value = random_id.rand_s3-bucket_id.hex
}