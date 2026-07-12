variable "identifier" {
  type = string
}

variable "vpc_id" {
  type = string
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

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}