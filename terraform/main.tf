terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"   
  config_context = var.context 
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "default" 
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "my-app"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "my-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "<IMAGE-HERE>"
          port {
            container_port = 9002
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "my-app-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = var.environment == "production" ? 80 : 32101
      target_port = 9002
      protocol    = "TCP"
    }

    type = var.environment == "production" ? "LoadBalancer" : "NodePort"
  }
}
