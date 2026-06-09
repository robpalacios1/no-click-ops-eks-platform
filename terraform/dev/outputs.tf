# ====================================================================
# 1. VPC DEV module Outputs
# ====================================================================

output "main_vpc_id" {
  description = "VPC ID"
  value       = module.vpc.main_vpc_id
}

output "public_subnets" {
  description = "Public Subnets"
  value = module.vpc.public_subnets_ids
}

output "private_subnets" {
  description = "Private Subnets"
  value = module.vpc.private_subnets_ids
}