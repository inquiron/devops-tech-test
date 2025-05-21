terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "~> 0.9"
    }
  }
}


provider "kubernetes" {
   config_path    = var.kube_config_path
   config_context = var.kube_config_context
}

# Kustomization provider
provider "kustomization" {
  kubeconfig_path    = var.kube_config_path
}
