locals {
  # These come from *.tfvars via variables.tf
  environment = var.environment
  kubeconfig  = var.kubeconfig

  # Common app values
  app_name     = "my-api"
  namespace    = "default"
  container    = "api"
  port         = 9002

  # Image (could be overwritten in CI)
  image        = "my-api-image:latest"

  # Paths
  overlay_path = "${path.module}/../kustomize/overlays/${local.environment}"
}