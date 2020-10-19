output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subent_ids" {
  value = module.network.public_subent_ids
}

output "private_subent_ids" {
  value = module.network.private_subent_ids
}
