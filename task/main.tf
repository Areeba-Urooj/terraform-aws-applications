#Create an EC2 instance using existing
#   VPC
#   Private_Subnet
#   Security_Group
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}