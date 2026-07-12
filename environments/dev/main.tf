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

  vpc_id = 

  security_group = var.secuirty_group

  identifier = local.name_prefix