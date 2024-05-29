resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "policy" {
  for_each = { for policy in var.policies : policy.policy_name => policy }

  name   = each.value.policy_name
  policy = replace(each.value.policy_template, "_arn_", var.arn)
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = aws_iam_policy.policy

  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}
