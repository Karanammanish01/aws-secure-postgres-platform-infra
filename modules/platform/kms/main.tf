locals {
  common_tags = {
    module = "kms"
  }

  merged_tags = merge(local.common_tags, var.tags)
}

resource "aws_kms_key" "this" {
  for_each                = var.self_kms_key
  description             = each.value.description
  enable_key_rotation     = each.value.enable_key_rotation
  deletion_window_in_days = each.value.deletion_window_in_days

  tags = merge(local.merged_tags,
    {
      Name = "${var.identifier}-${each.key}-cmk-key"
    }
  )
}

resource "aws_kms_alias" "this" {
  for_each = aws_kms_key.this

  name          = "alias/${var.identifier}-${each.key}-cmk-key"
  target_key_id = each.value.key_id
}