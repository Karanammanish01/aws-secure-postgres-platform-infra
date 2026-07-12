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