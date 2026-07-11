variable "cidr_block" {
  type = string
}

variable "identifier" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet" {
  description = "Subnet object"
  type = map(object({
    subnet_cidr_block        = string
    subnet_availability_zone = string
    subnet_type              = string
  }))
}