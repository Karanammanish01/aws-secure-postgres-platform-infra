# VPC MODULE

module "networking" {
  source = "../../modules/networking/network"

  cidr_block = var.vpc_cidr

  identifier = local.name_prefix

  subnet = var.vpc_subnet

}

# Module for Secuirty group

module "secuirty" {
  source = "../../modules/security/secuirty_group"

  vpc_id = module.networking.vpc_id

  security_group = var.security_group

  identifier = local.name_prefix

  ingress_rule = var.ingress_rule

  egress_rule = var.egress_rule
}

# IAM ROLE

module "iam_role_policy" {
  source = "../../modules/security/iam"

  identifier = local.name_prefix
}