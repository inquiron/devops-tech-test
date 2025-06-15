resource "null_resource" "kustomize_apply" {
  provisioner "local-exec" {
    command = "kubectl apply -k ../kustomize/overlays/${var.environment}"
  }

  triggers = {
    always_run = timestamp()
  }
}