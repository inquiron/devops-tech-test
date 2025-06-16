# Null resource to apply Kustomize overlay
resource "null_resource" "apply_kustomize" {
  provisioner "local-exec" {
    # Inline KUBECONFIG to guarantee correct context in CI/WSL2
    command = "KUBECONFIG=${var.kubeconfig_path} kubectl apply -k ${path.module}/../kustomize/overlays/${var.env} --validate=false"
  }

  triggers = {
    always_run = timestamp()  # Forces re-run on every apply
  }
}

# Conditionally create the secret only outside GitHub Actions
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
