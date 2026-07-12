locals {
  normal_tags = {
    module = "security"
  }

  merged_tags = merge(local.normal_tags, var.tags)
}

# AWS security group 

resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  for_each    = var.security_group
  description = each.value.description
  name        = "${identifier}-${each.value.security_group_resource}-sg"

  tags = local.merged_tags
}