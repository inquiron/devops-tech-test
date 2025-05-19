variable "kube_config_path" {
  type        = string
  description = "Path to kubeconfig file"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., local or production)"
}

variable "kustomize_path" {
  type        = string
  description = "Path to kustomize overlay"
}

variable "revision" {
  type        = string
  default     = "HEAD"
}

variable "target_namespace" {
  type        = string
  default     = "default"
}

variable "repo_url" {
  type        = string
  description = "Git repo URL containing Kustomize overlays"
}
