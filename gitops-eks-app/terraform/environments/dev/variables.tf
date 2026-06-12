variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_account_id" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "gitops-eks-dev"
}

variable "github_repo" {
  type = string
}
