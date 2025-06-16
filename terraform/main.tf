# Apply the Kustomize overlay using local-exec
resource "null_resource" "apply_kustomize" {
  provisioner "local-exec" {
    # Inline KUBECONFIG to guarantee correct context (works for CI, WSL2, etc.)
    command = "KUBECONFIG=${var.kubeconfig_path} kubectl apply -k ${path.module}/../kustomize/overlays/${var.env} --validate=false"
  }

  triggers = {
    # Forces re-run on every Terraform apply
    always_run = timestamp()
  }
}

# Conditionally create the Kubernetes secret only when not running in CI
resource "kubernetes_secret" "app_secret" {
  count = var.env == "ci" ? 0 : 1

  metadata {
    name      = "app-secret"
    namespace = "default"
  }

  data = {
    SECRET_KEY = base64encode(var.secret_key)
  }

  type = "Opaque"
}
