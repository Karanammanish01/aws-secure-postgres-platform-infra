variable "identifier" {
  description = "Identifier for the name"
  type        = string
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}