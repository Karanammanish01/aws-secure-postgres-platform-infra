locals {
  normal_tags = {
    module = "security"
  }

  merged_tags = merge(local.normal_tags, var.tags)
}

# AWS security group 

resource "aws_security_group" "this" {
  for_each = var.security_group

  vpc_id = var.vpc_id


  description = each.value.description
  name        = "${var.identifier}-${each.value.security_group_resource}-sg"

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-${each.value.security_group_resource}-sg"
  })
}

# Ingres Rules

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rule

  security_group_id = aws_security_group.this[each.value.security_group].id

  cidr_ipv4 = try(each.value.cidr_ipv4, null)

  referenced_security_group_id = (
    try(each.value.referenced_security_group, null) != null
    ? aws_security_group.this[each.value.referenced_security_group].id
    : null
  )

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol

  tags = local.merged_tags
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rule

  security_group_id = aws_security_group.this[each.value.security_group].id

  cidr_ipv4 = try(each.value.cidr_ipv4, null)

  referenced_security_group_id = (
    try(each.value.referenced_security_group, null) != null
    ? aws_security_group.this[each.value.referenced_security_group].id
    : null
  )

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol

  tags = local.merged_tags
}