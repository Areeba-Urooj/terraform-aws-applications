output "vpc" {
  value = module.vpc.vpc-id
}

output "public_subnet" {
  value = module.vpc.public-subnets
}
output "private_subnet" {
  value = module.vpc.private-subnets
}