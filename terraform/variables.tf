variable "environment" {
  description = "Local or production"
  type        = string
}

variable "context" {
  description = "Kubernetes context to use (docker-desktop or EKS)"
  type        = string
}