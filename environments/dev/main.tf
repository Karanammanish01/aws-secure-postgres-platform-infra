# Module for Secuirty group

module "secuirty" {
  source = "../../modules/security/secuirty_group"

  vpc_id = 

  security_group = var.secuirty_group

  identifier = local.name_prefix
}