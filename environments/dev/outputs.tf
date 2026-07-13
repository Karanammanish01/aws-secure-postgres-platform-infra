output "vpc_id" {
  value = module.networking.vpc_id
}

output "subnet-id" {
  value = module.networking.subnet_id
}

output "security_group_id" {
  value = module.secuirty.security_group_id
}

output "security_group_arn" {
  value = module.secuirty.security_group_arn
}