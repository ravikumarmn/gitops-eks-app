output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  description = "Copy this value → set as AWS_ROLE_ARN secret in gitops-eks-app"
  value       = module.iam.github_actions_role_arn
}

output "karpenter_controller_role_arn" {
  value = module.iam.karpenter_controller_role_arn
}

output "external_secrets_role_arn" {
  value = module.iam.external_secrets_role_arn
}

output "configure_kubectl" {
  description = "Run this after apply to configure kubectl"
  value       = "aws eks update-kubeconfig --region ap-south-1 --name ${module.eks.cluster_name}"
}
