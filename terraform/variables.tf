variable "kubeconfig" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "environment" {
  description = "Target environment (e.g., local, production)"
  type        = string
}