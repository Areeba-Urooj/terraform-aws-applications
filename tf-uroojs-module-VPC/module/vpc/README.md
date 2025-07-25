# Terraform AWS VPC Module

A Terraform module for creating an AWS VPC with configurable public and private subnets, Internet Gateway, and route tables.

## Overview

This Terraform module creates an AWS VPC infrastructure with a specified CIDR block. It also creates multiple subnets (public and private), and for public subnets, it sets up an Internet Gateway (IGW) and appropriate route tables.

## Features

- Creates a VPC with a specified CIDR block
- Creates public and private subnets
- Creates an Internet Gateway (IGW) for public subnets
- Sets up route tables for public subnets

## Usage

```hcl
module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "your_vpc_name"
  }

  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.0.0/24"
      az         = "eu-north-1a"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "eu-north-1b"
      public     = false
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_config | Configuration for the VPC | `object({cidr_block = string, name = string})` | n/a | yes |
| subnet_config | Configuration for subnets | `map(object({cidr_block = string, az = string, public = bool}))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| internet_gateway_id | ID of the Internet Gateway |

## Example with multiple subnets

```hcl
module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "production-vpc"
  }

  subnet_config = {
    public_subnet_1 = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
      public     = true
    }
    public_subnet_2 = {
      cidr_block = "10.0.2.0/24"
      az         = "us-east-1b"
      public     = true
    }
    private_subnet_1 = {
      cidr_block = "10.0.10.0/24"
      az         = "us-east-1a"
      public     = false
    }
    private_subnet_2 = {
      cidr_block = "10.0.11.0/24"
      az         = "us-east-1b"
      public     = false
    }
  }
}
```

## Notes

- Public subnets will have an Internet Gateway attached and route table configured for internet access
- Private subnets will not have internet access by default
- Make sure CIDR blocks don't overlap between subnets
- Choose availability zones that exist in your target AWS region