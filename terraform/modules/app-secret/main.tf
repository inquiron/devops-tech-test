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
