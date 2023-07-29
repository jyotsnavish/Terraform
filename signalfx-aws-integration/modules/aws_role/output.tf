output "role_arn" {
  value = aws_iam_role.aws_signalfx_role.arn
}

output "role_name" {
  value = aws_iam_role.aws_signalfx_role.name
}
