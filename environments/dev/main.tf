# VPC MODULE

module "networking" {
  source = "../../modules/networking/network"

  cidr_block = var.vpc_cidr

  identifier = local.name_prefix

  subnet = var.vpc_subnet
}

