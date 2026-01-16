output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "server_log_group_name" {
  value = module.logs.server_log_group_name
}

output "consumer_log_group_name" {
  value = module.logs.consumer_log_group_name
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
