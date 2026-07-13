output "security_group_id" {
  value = {
    for key, security_group in aws_security_group.this :
    key => security_group.id
  }
}

output "security_group_arn" {
  value = {
    for key, security_group in aws_security_group.this :
    key => security_group.arn
  }
}