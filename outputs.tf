output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "policy_id" {
  description = "ID of the inline policy"
  value       = try(aws_iam_role_policy.this[0].id, null)
}

output "policy_name" {
  description = "Name of the inline policy"
  value       = try(aws_iam_role_policy.this[0].name, null)
}

output "role" {
  description = "Role the policy is attached to"
  value       = try(aws_iam_role_policy.this[0].role, null)
}
