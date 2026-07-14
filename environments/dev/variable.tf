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

variable "self_kms_key" {
  description = "CMK keys details"
  type = map(object({
    description             = string
    deletion_window_in_days = number
    enable_key_rotation     = bool
  }))
}