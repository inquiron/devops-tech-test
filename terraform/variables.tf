variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., local or production)"
  type        = string
}

variable "secret_key" {
  description = "Secret key used by the app"
  type        = string
  sensitive   = true
}
