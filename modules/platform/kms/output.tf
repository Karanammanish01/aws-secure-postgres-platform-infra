output "alias_arn" {
  value ={
    for key, alias in aws_kms_alias.this :
            key => alias.arn
  }
}