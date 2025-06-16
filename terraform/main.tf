# Apply the Kustomize overlay using local-exec
resource "null_resource" "apply_kustomize" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${var.kubeconfig_path} kubectl apply -k ${path.module}/../kustomize/overlays/${var.env} --validate=false"
  }

  triggers = {
    always_run = timestamp()
  }
}

# Use the Kubernetes secret module
module "app_secret" {
  source      = "./modules/app-secret"
  env         = var.env
  secret_key  = var.secret_key
}
