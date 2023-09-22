provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77" # Check for the latest version

  name                 = "my-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0" # Check for the latest version
  
  cluster_name    = "my-cluster"
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "m5.large"
      key_name      = var.key_name
      subnets       = module.vpc.private_subnets
    }
  }
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group id attached to the EKS cluster."
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name attached to EKS cluster."
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Nestled base64-encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
}