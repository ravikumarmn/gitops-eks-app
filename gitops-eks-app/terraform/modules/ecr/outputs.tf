output "repository_urls" {
  description = "Map of service name to ECR URL"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}
