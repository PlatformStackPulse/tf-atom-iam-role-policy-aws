# Unit Tests for tf-atom-iam-role-policy-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: Assertions target plan-KNOWN values (the tf-label id string, the
# resource count, and input pass-throughs). Computed attributes such as the
# policy's real id/arn are unknown under a mock provider and are NOT asserted.

mock_provider "aws" {}

variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  role_name = "eg-test-thing-role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3Read"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::example-bucket/*"]
      }
    ]
  })
}

# ---------------------------------------------------------------------------
# Test: Module creates the inline policy when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true by default"
  }

  assert {
    condition     = length(aws_iam_role_policy.this) == 1
    error_message = "exactly one aws_iam_role_policy should be planned when enabled"
  }

  assert {
    condition     = aws_iam_role_policy.this[0].name == "eg-test-thing"
    error_message = "inline policy name should equal the tf-label id 'eg-test-thing'"
  }

  assert {
    condition     = aws_iam_role_policy.this[0].role == "eg-test-thing-role"
    error_message = "policy should be attached to the provided role_name"
  }
}

# ---------------------------------------------------------------------------
# Test: Module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when enabled = false"
  }

  assert {
    condition     = length(aws_iam_role_policy.this) == 0
    error_message = "no aws_iam_role_policy should be planned when disabled"
  }

  assert {
    condition     = output.policy_id == null
    error_message = "policy_id output should be null when disabled"
  }
}
