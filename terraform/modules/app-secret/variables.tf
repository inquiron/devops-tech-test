variable "secret_key" {
  description = "Secret key used by the app"
  type        = string
  sensitive   = true
}

variable "env" {
  description = "Deployment environment (e.g., local, production, ci)"
  type        = string
}
