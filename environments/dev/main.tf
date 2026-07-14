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

# Module for CMK 

module "kms_security" {
  source = "../../modules/platform/kms"

  identifier = local.name_prefix
  tags       = local.common_tags

  self_kms_key = {

    for key, value in var.self_kms_key :

    key => merge(
      value,
      {
        policy_statements = [

          {
            sid    = "AllowEC2Role"
            effect = "Allow"

            principal_type = "AWS"

            principal_identifiers = [
              module.iam_role_policy.instance_profile_arn
            ]

            actions = [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:GenerateDataKey",
              "kms:DescribeKey"
            ]

            resources = ["*"]
          },

          {
            sid    = "AllowSecretsManager"
            effect = "Allow"

            principal_type = "Service"

            principal_identifiers = [
              "secretsmanager.amazonaws.com"
            ]

            actions = [
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:GenerateDataKey",
              "kms:DescribeKey"
            ]

            resources = ["*"]
          }

        ]
      }
    )
  }
}