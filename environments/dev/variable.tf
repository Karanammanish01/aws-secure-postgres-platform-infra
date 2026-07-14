variable "environment" {
  type = string
  validation {

    condition = contains(
      ["dev", "uat", "prod"], var.environment
    )

    error_message = "Environment must be dev,uat and prod"
  }
}

variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Invalid CIDR block."
  }
}


variable "vpc_subnet" {
  description = "Subnet object"
  type = map(object({
    subnet_cidr_block        = string
    subnet_availability_zone = string
    subnet_type              = string
  }))
}

variable "security_group" {
  type = map(object({
    security_group_resource = string
    description             = string
  }))
}

variable "ingress_rule" {
  type = map(object({
    security_group            = string
    cidr_ipv4                 = optional(string)
    referenced_security_group = optional(string)
    from_port                 = number
    to_port                   = number
    ip_protocol               = string
  }))
}

variable "egress_rule" {
  type = map(object({
    security_group            = string
    cidr_ipv4                 = optional(string)
    referenced_security_group = optional(string)
    from_port                 = number
    to_port                   = number
    ip_protocol               = string
  }))
}

variable "project" {
  description = "Short project name, used to build name_prefix."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod), used to build name_prefix."
  type        = string
}

variable "self_kms_key" {
  description = <<-EOT
    Map of KMS keys to create, passed through to the kms module. Map key is
    used to build each key's name/alias and must only contain characters
    valid in an alias name ([a-zA-Z0-9/_-]).
  EOT

  type = map(object({
    description              = string
    enable_key_rotation      = optional(bool, true)
    deletion_window_in_days  = optional(number, 30)
    multi_region             = optional(bool, false)
    is_enabled               = optional(bool, true)
    policy_statements = optional(list(object({
      sid                    = string
      effect                 = string
      principal_type         = string
      principal_identifiers  = list(string)
      actions                = list(string)
      resources              = list(string)
    })), [])
  }))
}