variable "identifier" {
  description = "Prefix used when naming each key/alias, e.g. \"<identifier>-<map key>-cmk-key\"."
  type        = string
}

variable "tags" {
  description = "Tags merged onto every key created by this module (module tag and per-key Name are added automatically)."
  type        = map(string)
  default     = {}
}

variable "prevent_destroy" {
  description = "Module-wide lifecycle guard applied to every key. Set to false if you need to allow destroys (e.g. in throwaway/test environments)."
  type        = bool
  default     = true
}

variable "self_kms_key" {
  description = <<-EOT
    Map of KMS keys to create. Map key is used to build the key's name/alias
    (<identifier>-<map key>-cmk-key) and must therefore only contain
    characters valid in an alias name ([a-zA-Z0-9/_-]).

    Each value supports:
      description              - (required) Key description.
      enable_key_rotation      - (optional) Defaults to true if unset or null.
      deletion_window_in_days  - (required) 7-30.
      multi_region             - (optional) Defaults to false.
      is_enabled               - (optional) Defaults to true.
      policy_statements        - (optional) Extra IAM policy statements appended
                                  after the always-included root-account
                                  full-access statement. Each entry supports:
                                    sid                    - string
                                    effect                 - "Allow" or "Deny"
                                    principal_type         - e.g. "AWS", "Service"
                                    principal_identifiers  - list(string)
                                    actions                - list(string)
                                    resources              - list(string)
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

  validation {
    condition = alltrue([
      for k, v in var.self_kms_key : v.deletion_window_in_days >= 7 && v.deletion_window_in_days <= 30
    ])
    error_message = "deletion_window_in_days must be between 7 and 30 for every key."
  }

  validation {
    condition = alltrue([
      for k, v in var.self_kms_key : can(regex("^[a-zA-Z0-9/_-]+$", k))
    ])
    error_message = "Each map key in self_kms_key must only contain letters, numbers, '/', '_' or '-' (it's used to build the alias name)."
  }
}