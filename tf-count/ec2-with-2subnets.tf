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
resource "aws_instance" "ec2-server" {
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  count = 4
  subnet_id = element(aws_subnet.subnets[*].id, count.index % length(aws_subnet.subnets))
  # 0%2 = 0
  # 1%2 = 1
  # 2%2 = 0
  # 3%2 = 1
  tags = {
    Name = "${local.tags.Name}-instance-${count.index}"
  }
}
output "count-subnets" {
  value = aws_subnet.subnets[0].id
}
output "count-subnets" {
  value = aws_subnet.subnets[1].id
}