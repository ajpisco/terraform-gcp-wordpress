output "network_name" {
  description = "VPC Network name"
  value       = module.vpc.network_name
}

output "network_id" {
  description = "VPC Network ID"
  value       = module.vpc.network_id
}

output "subnets" {
  description = "List of subnets created"
  value       = module.subnet[0]
}

output "public_address" {
  description = "Public address to be used by LB"
  value       = module.public_address.addresses[0]
}