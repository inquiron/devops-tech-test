variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "secret_key" {
  description = "Secret key used by the app"
  type        = string
  sensitive   = true
}
