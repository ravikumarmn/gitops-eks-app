# Terraform — EKS Platform Infrastructure

Provisions: VPC, EKS cluster, ECR repositories, and IAM roles (GitHub Actions OIDC, Karpenter, ESO, ADOT).

## Prerequisites

- AWS CLI configured (`aws configure` or assume a role)
- Terraform >= 1.6 (`brew install terraform`)
- Account ID: `232778956081`, Region: `ap-south-1`

---

## Step 0 — Bootstrap Remote State (one-time, manual)

Run these AWS CLI commands **once** before the first `terraform init`.
The S3 bucket and DynamoDB table are not managed by Terraform to avoid the chicken-and-egg problem.

```bash
# S3 bucket for state
aws s3api create-bucket \
  --bucket gitops-eks-tfstate-232778956081 \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# Enable versioning so you can recover from bad applies
aws s3api put-bucket-versioning \
  --bucket gitops-eks-tfstate-232778956081 \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket gitops-eks-tfstate-232778956081 \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# DynamoDB table for state locking
aws dynamodb create-table \
  --table-name gitops-eks-tfstate-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

---

## Step 1 — GitHub Actions OIDC Provider (one-time, manual)

GitHub Actions needs an OIDC provider in your AWS account before Terraform can create the role.

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

> If it already exists (error: EntityAlreadyExists), skip this — you're good.

---

## Step 2 — Apply

```bash
cd terraform/environments/dev

terraform init
terraform plan
terraform apply   # ~15 min for EKS cluster
```

---

## Step 3 — After Apply: set AWS_ROLE_ARN secret

```bash
# Get the role ARN from Terraform output
ROLE_ARN=$(terraform output -raw github_actions_role_arn)
echo $ROLE_ARN

# Set the GitHub Actions secret
gh secret set AWS_ROLE_ARN \
  --repo ravikumarmn/gitops-eks-app \
  --body "$ROLE_ARN"
```

---

## Step 4 — Configure kubectl

```bash
aws eks update-kubeconfig --region ap-south-1 --name gitops-eks-dev
kubectl get nodes
```

---

## Cost Warning

This cluster costs ~₹80/day on-demand (2x t3.medium nodes + NAT gateways).

**Always destroy after your session:**

```bash
cd terraform/environments/dev
terraform destroy
```

---

## Module Overview

| Module | What it creates |
|---|---|
| `modules/vpc` | VPC, 3 public + 3 private subnets, NAT gateways, ELB subnet tags |
| `modules/eks` | EKS 1.29 cluster, managed node group (system pods), OIDC provider |
| `modules/ecr` | 5 ECR repos with image scanning + lifecycle policy (keep last 10) |
| `modules/iam` | GitHub Actions OIDC role, Karpenter IRSA, ESO IRSA, ADOT IRSA |
