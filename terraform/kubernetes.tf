terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "google_key" {
  type = string
  sensitive = true  
}

variable "env" {
  type = string
}

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

resource "kubernetes_secret" "dtt_google_secret" {
  metadata {
    name = "${var.env}-dtt-google-secrets"
  }
  data = {
    "GOOGLE_KEY" = var.google_key
  }
}

# Ref: https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider
resource "kubernetes_deployment" "dtt_deployment" {
  metadata {
    name = "${var.env}-dtt-deployment"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${var.env}-devops-tech-test-pod"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.env}-devops-tech-test-pod"
        }
      }
      spec {
        container {
          name  = "${var.env}-devops-tech-test"
          image = "241793127680.dkr.ecr.eu-west-2.amazonaws.com/devops-tech-test:latest"

          port {
            container_port = 7007
            name = "geocode"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          env {
            name = "APP_PORT"
            value = "7007"
          }
          env {
            name = "GOOGLE_KEY"
            value_from {
              secret_key_ref {
                name = "${var.env}-dtt-google-secrets"
                key = "GOOGLE_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dtt_service" {
  metadata {
    name = "${var.env}-dtt-service"
    annotations = {
    "service.beta.kubernetes.io/aws-load-balancer-type": "external",
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type": "ip",
    "service.beta.kubernetes.io/aws-load-balancer-scheme": "internet-facing",
    }
  }
  spec {
    selector = {
      "app" = "${var.env}-devops-tech-test-pod"
    }
    type = "LoadBalancer"
    port {
      port = 80
      target_port = "geocode"
    }
  }
  
}