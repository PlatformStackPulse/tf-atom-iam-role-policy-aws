variable "role_name" {
  description = "Name of the IAM role to embed the inline policy in"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name))
    error_message = "role_name must contain only valid IAM role name characters."
  }
}

variable "policy" {
  description = "JSON-encoded IAM policy document"
  type        = string
  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "policy must be valid JSON."
  }
}
