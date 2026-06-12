terraform {
  backend "s3" {
    bucket         = "gitops-eks-tfstate-232778956081"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "gitops-eks-tfstate-lock"
    encrypt        = true
  }
}
