provider "kubernetes" {
  config_path = var.kubeconfig
}
terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37.1"
    }
  }
}
