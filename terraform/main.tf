terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

locals {
  vpc_id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

# Example output for subnets
output "eks_subnet_ids" {
  value = data.aws_subnets.eks_subnets.ids
}
