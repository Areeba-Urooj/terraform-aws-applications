# Terraform AWS IAM Users and VPC Management

This Terraform configuration creates AWS IAM users with role-based access policies and manages VPC infrastructure in the `eu-north-1` region. The project demonstrates automated user provisioning with different permission levels based on YAML configuration.

## Project Overview

This project automates the creation of:
- IAM users with auto-generated passwords
- Role-based policy attachments for users
- VPC infrastructure using modules
- Dynamic user-role mapping from YAML configuration

## Architecture

- **Provider**: AWS (eu-north-1 region)
- **User Management**: Dynamic IAM user creation from YAML file
- **Access Control**: Policy-based permissions (EC2, S3)
- **Infrastructure**: VPC with public and private subnets
- **Configuration**: YAML-driven user and role definitions

## User Configuration

The project uses a YAML file (`users.yaml`) to define users and their roles:

```yaml
users:
  - username: Areeba
    roles: [AmazonEC2FullAccess]
  - username: Urooj
    roles: [AmazonS3ReadOnlyAccess]
  - username: Brohi
    roles: [AmazonS3ReadOnlyAccess, AmazonEC2FullAccess]
```

### User Details
- **Areeba**: EC2 Full Access permissions
- **Urooj**: S3 Read-Only Access permissions  
- **Brohi**: Both S3 Read-Only and EC2 Full Access permissions

## Features

### Dynamic User Creation
- Reads user configuration from `users.yaml`
- Creates IAM users automatically
- Generates secure 12-character passwords
- Supports multiple roles per user

### Policy Management
- Attaches AWS managed policies based on role definitions
- Supports flexible user-role combinations
- Uses `for_each` loops for efficient resource creation

### VPC Infrastructure
- Creates VPC using Terraform modules
- Provisions public and private subnets
- Outputs VPC and subnet IDs for reference

## Prerequisites

- AWS CLI configured with appropriate administrative credentials
- Terraform installed (version compatible with AWS provider 6.4.0)
- Permissions to create IAM users, policies, and VPC resources

## Usage

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd <project-directory>
```

### 2. Customize User Configuration
Edit `users.yaml` to define your users and their roles:
```yaml
users:
  - username: YourUsername
    roles: [AmazonEC2FullAccess, AmazonS3ReadOnlyAccess]
  - username: AnotherUser
    roles: [AmazonS3ReadOnlyAccess]
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan Deployment
```bash
terraform plan
```

### 5. Apply Configuration
```bash
terraform apply
```

### 6. Retrieve User Passwords
```bash
# Get user login profiles (passwords are auto-generated)
terraform output
```

## Terraform Apply Output

![Terraform Apply Output 1](images/terraform-apply-1.png)
*Initial terraform apply showing resource planning*

![Terraform Apply Output 2](images/terraform-apply-2.png)
*User creation and policy attachment progress*

![Terraform Apply Output 3](images/terraform-apply-3.png)
*Final apply results with outputs*

## AWS Console Verification

![AWS Console - IAM Users](images/aws-console-1.png)
*IAM Users created in AWS Console*

![AWS Console - User Policies](images/aws-console-2.png)
*Policy attachments for users*

![AWS Console - VPC Resources](images/aws-console-3.png)
*VPC infrastructure in AWS Console*

## Configuration Details

### Local Variables
```hcl
locals {
  user_data = yamldecode(file("./users.yaml")).users
  
  user_role_pair = flatten([
    for user in local.user_data: [
      for role in user.roles: {
        user = user.username
        role = role
      }
    ]
  ])
}
```

### Resources Created
1. **IAM Users**: One for each user defined in `users.yaml`
2. **Login Profiles**: Auto-generated passwords for console access
3. **Policy Attachments**: AWS managed policies based on role assignments
4. **VPC Module**: Network infrastructure

### Outputs
- `vpc`: VPC ID from the module
- `public-subnet`: Public subnet ID
- `private-subnet`: Private subnet ID
- `usre-roles`: User-role mapping pairs
- `name`: List of all usernames

## Security Features

### Password Management
- 12-character auto-generated passwords
- Lifecycle management prevents accidental password changes
- Console access enabled for all users

### Access Control
- Uses AWS managed policies for consistent permissions
- Role-based access control (RBAC)
- Principle of least privilege applied

## Supported AWS Policies

The configuration supports any AWS managed policy. Common examples:
- `AmazonEC2FullAccess`
- `AmazonS3ReadOnlyAccess`
- `AmazonS3FullAccess`
- `PowerUserAccess`
- `ReadOnlyAccess`

## Adding New Users

1. Edit `users.yaml`:
```yaml
users:
  - username: NewUser
    roles: [AmazonEC2ReadOnlyAccess]
```

2. Apply changes:
```bash
terraform plan
terraform apply
```

## Removing Users

1. Remove user from `users.yaml`
2. Apply changes:
```bash
terraform apply
```

**Note**: This will delete the user and all associated resources.

## Troubleshooting

### Common Issues

1. **Policy not found**: Ensure policy ARNs are correct AWS managed policies
2. **Permission denied**: Verify AWS credentials have IAM administrative permissions
3. **YAML parsing error**: Validate YAML syntax in `users.yaml`

### Validation Commands
```bash
# Verify users exist
aws iam list-users --region eu-north-1

# Check user policies
aws iam list-attached-user-policies --user-name <username>

# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('users.yaml'))"
```

## Best Practices

1. **Regular Rotation**: Implement password rotation policies
2. **Access Review**: Regularly audit user permissions
3. **Monitoring**: Enable CloudTrail for user activity monitoring
4. **MFA**: Consider enabling MFA for console users
5. **Backup**: Keep backup of `users.yaml` configuration

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

**Warning**: This will delete all IAM users and their access credentials.

## Advanced Configuration

### Adding Custom Policies
To use custom policies instead of AWS managed policies:

1. Create the policy resource
2. Update the policy ARN in the attachment resource

### Multiple Environments
Consider using Terraform workspaces for different environments:
```bash
terraform workspace new production
terraform workspace new staging
```

## Security Considerations

- Store `terraform.tfstate` securely (consider remote backend)
- Use least privilege principle when assigning roles
- Monitor user activities through CloudTrail
- Implement password policies and MFA where appropriate
- Regularly review and audit user permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test configuration changes
4. Update documentation
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
