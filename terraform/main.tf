resource "kubernetes_namespace" "app" {
  metadata {
    name = var.kustomize_namespace
  }
}

# Build kustomize manifests for the selected environment
data "kustomization_build" "app" {
  path = "${path.module}/../kustomize/overlays/${var.environment}"
}

# Deploy all resources from the build
resource "kustomization_resource" "app" {
  for_each = data.kustomization_build.app.ids

  manifest = data.kustomization_build.app.manifests[each.value]
  depends_on = [kubernetes_namespace.app]
}
