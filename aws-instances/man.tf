terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}
resource "aws_instance" "WebServer_Stolkholme" {
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  tags = {
    Name = "WebServer_Stolkholme"
  }
}
