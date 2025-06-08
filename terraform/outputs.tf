output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  value = data.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = data.aws_subnets.eks_subnets.ids
}
