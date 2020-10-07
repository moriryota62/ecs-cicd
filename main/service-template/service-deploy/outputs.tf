output "dns_name" {
  value = module.alb.dns_name
}

output "sg_id" {
  value = module.service.sg_id
}