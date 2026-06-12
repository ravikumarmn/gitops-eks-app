output "github_actions_role_arn" {
  description = "Set this as AWS_ROLE_ARN secret in gitops-eks-app GitHub repo"
  value       = aws_iam_role.github_actions.arn
}

output "karpenter_controller_role_arn" {
  value = aws_iam_role.karpenter_controller.arn
}

output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}

output "adot_role_arn" {
  value = aws_iam_role.adot.arn
}
