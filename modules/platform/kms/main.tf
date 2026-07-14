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

  policy = data.aws_iam_policy_document.this[each.key].json

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

# Getting the account id
data "aws_caller_identity" "current" {}

# creating the policy 
data "aws_iam_policy_document" "this" {


  for_each = var.self_kms_key
  # This should always be there
  statement {
    sid = "EnableRootPermission"

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }
}