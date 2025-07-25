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
  region = "eu-north-1"
}
locals {
  tags = {
    Name = "Prject-1"
  }
}
resource "aws_vpc" "myserver-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.tags.Name}-vpc"
  }
}
resource "aws_subnet" "subnets" {
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = aws_vpc.myserver-vpc.id
  count = 2
  tags = {
    Name = "${local.tags.Name}-subnet-${count.index}"
  }
}
output "count-subnets" {
  value = aws_subnet.subnets[0].id
}
output "count-subnets" {
  value = aws_subnet.subnets[1].id
}