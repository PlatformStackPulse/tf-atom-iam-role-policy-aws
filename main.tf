# -----------------------------------------------------
# Atom: IAM Role Policy (Inline)
# Creates a single inline IAM policy embedded in a role.
# -----------------------------------------------------
resource "aws_iam_role_policy" "this" {
  count = module.this.enabled ? 1 : 0

  name   = module.this.id
  role   = var.role_name
  policy = var.policy
}
