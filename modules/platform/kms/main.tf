locals {
  common_tags = {
    module = "kms"
  }

  merged_tags = merge(local.common_tags, var.tags)
}

# Getting the account id
data "aws_caller_identity" "current" {}

# creating the policy
data "aws_iam_policy_document" "this" {

  for_each = var.self_kms_key

  statement {

    sid = "EnableRootPermissions"

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

  dynamic "statement" {

    # each.value.policy_statements defaults to [] via the variable's optional()
    # type constraint, so this is safe even when a caller omits it entirely.
    for_each = each.value.policy_statements

    content {

      sid = statement.value.sid

      effect = statement.value.effect

      principals {

        type = statement.value.principal_type

        identifiers = statement.value.principal_identifiers
      }

      actions = statement.value.actions

      resources = statement.value.resources
    }
  }
}

resource "aws_kms_key" "this" {

  for_each = var.self_kms_key

  description = each.value.description

  # Defaults to true even if a caller explicitly sets this to null, so
  # rotation never silently falls back to AWS's off-by-default behavior.
  enable_key_rotation = coalesce(each.value.enable_key_rotation, true)

  deletion_window_in_days = each.value.deletion_window_in_days

  multi_region = each.value.multi_region

  is_enabled = each.value.is_enabled

  policy = data.aws_iam_policy_document.this[each.key].json

  tags = merge(
    local.merged_tags,
    {
      Name = "${var.identifier}-${each.key}-cmk-key"
    }
  )

  lifecycle {
    # Module-wide toggle rather than per-key, since lifecycle arguments
    # must be static and can't reference each.value.
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "this" {
  for_each = aws_kms_key.this

  name          = "alias/${var.identifier}-${each.key}-cmk-key"
  target_key_id = each.value.key_id
}