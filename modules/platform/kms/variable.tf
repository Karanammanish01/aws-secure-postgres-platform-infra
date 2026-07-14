variable "identifier" {
  type = string
}

variable "self_kms_key" {
  description = "CMK keys details"
  type = map(object({
    description             = string
    deletion_window_in_days = number
    enable_key_rotation     = bool
  }))
}

variable "tags" {
  description = "Tag for the resource"
  type        = map(string)
  default     = {}
}