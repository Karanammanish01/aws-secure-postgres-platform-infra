output "key_ids" {
  description = "Map of map-key to KMS key ID."
  value       = { for k, v in aws_kms_key.this : k => v.key_id }
}

output "key_arns" {
  description = "Map of map-key to KMS key ARN."
  value       = { for k, v in aws_kms_key.this : k => v.arn }
}

output "alias_names" {
  description = "Map of map-key to alias name."
  value       = { for k, v in aws_kms_alias.this : k => v.name }
}

output "alias_arns" {
  description = "Map of map-key to alias ARN."
  value       = { for k, v in aws_kms_alias.this : k => v.arn }
}

output "policies" {
  description = "Map of map-key to the effective key policy JSON."
  value       = { for k, v in data.aws_iam_policy_document.this : k => v.json }
}
