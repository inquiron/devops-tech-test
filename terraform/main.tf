# resource "null_resource" "kustomize_apply" {
#   provisioner "local-exec" {
#     command = "kubectl apply -k ${var.kustomize_overlay_path}"
#   }
#
#   triggers = {
#     environment = var.environment
#     always_run = "${timestamp()}"
#   }
# }


resource "local_file" "argocd_app" {
  content = templatefile("${path.module}/argocd_app.yaml", {
    ENVIRONMENT     = var.environment
    REPO_URL        = var.repo_url
    REVISION        = var.revision
    KUSTOMIZE_PATH  = var.kustomize_path
    TARGET_NAMESPACE = var.target_namespace
  })
  filename = "${path.module}/generated_argocd_app.yaml"
}

resource "null_resource" "apply_argocd_app" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.argocd_app.filename}"
  }

  depends_on = [local_file.argocd_app]
}
