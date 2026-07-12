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

variable "tags" {
  description = "Tags for the resource"
  type        = map(object)
  default     = {}
}