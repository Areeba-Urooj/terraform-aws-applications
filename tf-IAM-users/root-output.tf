output "vpc" {
  value = module.vpc.vpc_id
}
output "public-subnet" {
  value = module.vpc.public_subnet
}
output "private-subnet" {
  value = module.vpc.private_subnet
}