variable "cluster_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "github_repo" {
  description = "GitHub repo in owner/name format for OIDC trust"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN (from eks module output)"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL without https:// prefix"
  type        = string
}
