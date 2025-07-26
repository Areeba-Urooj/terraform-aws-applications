# Terraform AWS VPC Module

A flexible and reusable Terraform module for creating AWS VPC infrastructure with configurable public and private subnets, Internet Gateway, and route tables.

## Overview

This Terraform module creates a complete AWS VPC infrastructure with a specified CIDR block. It supports creating multiple subnets (both public and private) across different availability zones, and automatically sets up Internet Gateway and routing for public subnets.

## Architecture

The module creates the following AWS resources:
- **VPC** with custom CIDR block
- **Public Subnets** with internet access via Internet Gateway
- **Private Subnets** for internal resources
- **Internet Gateway** for public subnet connectivity
- **Route Tables** with appropriate routing rules
- **Route Table Associations** linking subnets to route tables

## Features

✅ **Flexible VPC Configuration**: Specify custom CIDR blocks and VPC names  
✅ **Multi-AZ Support**: Deploy subnets across multiple availability zones  
✅ **Public/Private Subnet Types**: Configure subnets as public or private  
✅ **Automatic Internet Gateway**: Public subnets get internet access automatically  
✅ **Smart Routing**: Route tables are created and associated based on subnet type  
✅ **Scalable Design**: Add as many subnets as needed  
✅ **Production Ready**: Follows AWS best practices  

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| aws | >= 3.0 |

## Usage

### Basic Example

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
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

### Production Example with Multiple Subnets

```hcl
module "vpc" {
  source = "./modules/vpc"

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

### Complete Implementation Example

```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "production-vpc"
  }

  subnet_config = {
    web_subnet_1 = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
      public     = true
    }
    web_subnet_2 = {
      cidr_block = "10.0.2.0/24"
      az         = "us-east-1b"
      public     = true
    }
    app_subnet_1 = {
      cidr_block = "10.0.10.0/24"
      az         = "us-east-1a"
      public     = false
    }
    app_subnet_2 = {
      cidr_block = "10.0.11.0/24"
      az         = "us-east-1b"
      public     = false
    }
    db_subnet_1 = {
      cidr_block = "10.0.20.0/24"
      az         = "us-east-1a"
      public     = false
    }
    db_subnet_2 = {
      cidr_block = "10.0.21.0/24"
      az         = "us-east-1b"
      public     = false
    }
  }
}

# Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_config | Configuration for the VPC | `object({`<br>`cidr_block = string`<br>`name = string`<br>`})` | n/a | yes |
| subnet_config | Configuration for subnets | `map(object({`<br>`cidr_block = string`<br>`az = string`<br>`public = bool`<br>`}))` | n/a | yes |

### Input Details

#### vpc_config
- **cidr_block**: CIDR block for the VPC (e.g., "10.0.0.0/16")
- **name**: Name tag for the VPC

#### subnet_config
- **cidr_block**: CIDR block for the subnet (must be within VPC CIDR)
- **az**: Availability zone for the subnet (e.g., "us-east-1a")
- **public**: Boolean flag - true for public subnets, false for private

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| public_subnet_ids | Map of public subnet names to their IDs |
| private_subnet_ids | Map of private subnet names to their IDs |
| internet_gateway_id | ID of the Internet Gateway (if public subnets exist) |

## Terraform Apply Demonstrations

The following screenshots show the module deployment process:

![Terraform Apply Output 1](images/terraform-apply-1.png)
*Terraform initialization and planning phase*

![Terraform Apply Output 2](images/terraform-apply-2.png)
*VPC creation in progress*

![Terraform Apply Output 3](images/terraform-apply-3.png)
*Public subnets being created*

![Terraform Apply Output 4](images/terraform-apply-4.png)
*Private subnets creation*

![Terraform Apply Output 5](images/terraform-apply-5.png)
*Internet Gateway and route table setup*

![Terraform Apply Output 6](images/terraform-apply-6.png)
*Route table associations being created*

![Terraform Apply Output 7](images/terraform-apply-7.png)
*Final deployment completion with outputs*

## AWS Console Verification

Screenshots from AWS Management Console showing the created infrastructure:

![AWS Console VPC View](images/aws-console-1.png)
*VPC Dashboard showing the created VPC and its components*

![AWS Console Subnets View](images/aws-console-2.png)
*Subnets view showing public and private subnets across availability zones*

## Module Structure

```
modules/vpc/
├── main.tf              # Main resource definitions
├── variables.tf         # Input variable definitions  
├── outputs.tf          # Output definitions
├── versions.tf         # Provider version constraints
└── README.md           # This documentation
```

## Resource Naming Convention

The module follows a consistent naming pattern:
- **VPC**: Uses the provided name from `vpc_config.name`
- **Subnets**: Uses the key name from `subnet_config` map
- **Internet Gateway**: `{vpc_name}-igw`
- **Route Tables**: `{vpc_name}-public-rt` for public subnets

## Best Practices

### CIDR Planning
- Use RFC 1918 private address spaces (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- Ensure subnet CIDR blocks don't overlap
- Plan for future growth - don't use all available IP space immediately

### Availability Zone Distribution
- Distribute subnets across multiple AZs for high availability
- Use at least 2 AZs for production workloads
- Verify AZ availability in your target region

### Subnet Sizing
- /24 subnets provide 251 usable IP addresses
- /28 subnets provide 11 usable IP addresses (minimum for most use cases)
- Reserve IP space for future expansion

## Common Use Cases

### 1. Web Application (3-Tier Architecture)
```hcl
subnet_config = {
  web_public_1 = {
    cidr_block = "10.0.1.0/24"
    az         = "us-east-1a"
    public     = true
  }
  web_public_2 = {
    cidr_block = "10.0.2.0/24"
    az         = "us-east-1b"
    public     = true
  }
  app_private_1 = {
    cidr_block = "10.0.10.0/24"
    az         = "us-east-1a"
    public     = false
  }
  app_private_2 = {
    cidr_block = "10.0.11.0/24"
    az         = "us-east-1b"
    public     = false
  }
  db_private_1 = {
    cidr_block = "10.0.20.0/24"
    az         = "us-east-1a"
    public     = false
  }
  db_private_2 = {
    cidr_block = "10.0.21.0/24"
    az         = "us-east-1b"
    public     = false
  }
}
```

### 2. Simple Public/Private Setup
```hcl
subnet_config = {
  public = {
    cidr_block = "10.0.1.0/24"
    az         = "us-east-1a"
    public     = true
  }
  private = {
    cidr_block = "10.0.2.0/24"
    az         = "us-east-1a"
    public     = false
  }
}
```

## Important Notes

⚠️ **Critical Considerations**:
- **Public subnets** automatically get Internet Gateway access and route tables configured
- **Private subnets** have no internet access by default (add NAT Gateway separately if needed)
- **CIDR blocks** must not overlap between subnets
- **Availability zones** must exist in your target AWS region
- **Route tables** are automatically created and associated based on subnet type

💡 **Tips**:
- Use meaningful names for subnet keys (e.g., `web_public_1`, `db_private_1`)
- Plan your CIDR blocks carefully to avoid conflicts
- Consider using data sources to fetch available AZs dynamically
- Test in development environment before production deployment

## Troubleshooting

### Common Issues

1. **CIDR Block Conflicts**
   ```
   Error: InvalidSubnet.Conflict: The CIDR '10.0.1.0/24' conflicts with another subnet
   ```
   **Solution**: Ensure all subnet CIDR blocks are unique and within the VPC CIDR range.

2. **Invalid Availability Zone**
   ```
   Error: InvalidParameterValue: Value (us-east-1d) for parameter availabilityZone is invalid
   ```
   **Solution**: Use `aws ec2 describe-availability-zones` to list valid AZs in your region.

3. **Route Table Association Issues**
   ```
   Error: Resource already associated with another route table
   ```
   **Solution**: Check for existing route table associations that might conflict.

### Validation Commands

```bash
# List available availability zones
aws ec2 describe-availability-zones --region us-east-1

# Validate VPC CIDR
aws ec2 describe-vpcs --vpc-ids vpc-xxxxxxxxx

# Check subnet configuration
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxxxxxx"
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/enhancement`)
3. Make your changes following the established patterns
4. Test thoroughly with different configurations
5. Update documentation if needed
6. Submit a pull request

## Versioning

This module follows [Semantic Versioning](https://semver.org/). Check the [releases page](../../releases) for version history.

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions, issues, or contributions:
- Create an issue in the repository
- Review existing documentation
- Check AWS VPC documentation for service-specific questions

---
