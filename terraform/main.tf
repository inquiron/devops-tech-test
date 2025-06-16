resource "null_resource" "apply_kustomize" {
  provisioner "local-exec" {
    # Inline KUBECONFIG to guarantee the correct context is used (especially in WSL2/CI)
    command = "KUBECONFIG=${var.kubeconfig_path} kubectl apply -k ${path.module}/../kustomize/overlays/${var.env} --validate=false"
  }

  triggers = {
    # Forces this resource to re-run on every terraform apply
    always_run = timestamp()
  }
}

resource "kubernetes_secret" "app_secret" {
  metadata {
    name      = "app-secret"
    namespace = "default"
  }

  data = {
    SECRET_KEY = base64encode(var.secret_key)
  }

  type = "Opaque"
}
