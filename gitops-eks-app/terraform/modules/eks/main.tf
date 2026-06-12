module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Private API endpoint — nodes talk to API server without leaving AWS network
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true  # set false after bastion is ready

  cluster_addons = {
    coredns                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true }
    aws-ebs-csi-driver     = { most_recent = true }
  }

  # Managed node group handles system pods (CoreDNS, kube-proxy, ArgoCD, etc.)
  # App workload nodes are handled by Karpenter
  eks_managed_node_groups = {
    system = {
      instance_types = var.node_group_instance_types
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size

      labels = {
        role = "system"
      }

      taints = []
    }
  }

  # Allow cluster to manage node IAM role for Karpenter
  enable_cluster_creator_admin_permissions = true

  tags = {
    Terraform                                  = "true"
    Environment                                = "dev"
    "karpenter.sh/discovery"                   = var.cluster_name
  }
}
