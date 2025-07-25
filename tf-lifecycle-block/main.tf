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

resource "aws_security_group" "main" {
  name = "my-sg"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  
  lifecycle {
    create_before_destroy = true #When you're creating different instance and need to delete the older one.
    prevent_destroy = true #If you want to prevent deleting your instance even by accident
  }
}


#A common usecase where when u make a small change in a resource and don't want it to be created all over again.
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}