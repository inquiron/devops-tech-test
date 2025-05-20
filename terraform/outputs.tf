output "deployed_namespace" {
  value = var.kustomize_namespace
}

output "cluster_type" {
  description = "Indicates whether the deployment is to a local or remote Kubernetes cluster"
  value       = var.use_local_cluster ? "local" : "remote"
}
