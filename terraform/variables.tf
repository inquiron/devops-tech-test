variable "kube_config_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_config_context" {
  description = "Kubeconfig context name"
  type        = string
  default     = "minikube"
}

variable "environment" {
  description = "Deployment environment (local or production)"
  type        = string
}

variable "kustomize_namespace" {
  description = "Namespace used in the Kustomize overlays"
  type        = string
}

variable "use_local_cluster" {
  description = "Set to true for local (Minikube) cluster, false for remote (EKS)"
  type        = bool
}


