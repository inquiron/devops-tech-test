# Phase 4 – Kubernetes Deployment with Kustomize

This document details the implementation of **Phase 4** of the DevOps Technical Test project. The goal of this phase was to deploy the Node.js application into a Kubernetes environment using Kustomize, applying best practices in pod security, resource configuration, autoscaling, and deployment overlays.

## Objectives Completed

- Created Kubernetes manifests for:

  - Deployment
  - Service
  - ConfigMap
  - Secret
  - ServiceAccount
  - HorizontalPodAutoscaler
  - NetworkPolicy
  - Ingress (production overlay)

- Defined resource requests and limits
- Added liveness and readiness probes
- Enforced strict securityContext for containers and pods
- Set up overlays for `local` and `production` environments
- Enabled HPA (Horizontal Pod Autoscaler)
- Exposed configuration via ConfigMap and Secret
- Integrated config validation using `kubeval`

## 1. Base Resources (kustomize/base)

Created base Kubernetes resources to standardise deployment:

- **Deployment.yaml** with:

  - Pod-level `securityContext` (non-root user, `readOnlyRootFilesystem`)
  - Application container exposing port `9002`
  - Resource requests/limits for CPU and memory
  - Liveness and readiness probes on `/healthz`
  - Environment variables sourced from ConfigMap and Secret
  - Logging volume mount `/var/log/app`

- **Service.yaml**: ClusterIP service targeting port `9002`

- **ConfigMap.yaml** and **Secret.yaml**: Inject `APP_PORT` and `SECRET_KEY`

- **ServiceAccount.yaml**: Custom ServiceAccount for pod binding

- **NetworkPolicy.yaml**: Restricts traffic to only necessary pods

## 2. Overlay Configuration

### Local Overlay (`kustomize/overlays/local`)

- Sets `replicas: 1`
- Exposes service via `NodePort`
- Patch image using latest dev tag
- No Ingress; accessible via node port for local testing

### Production Overlay (`kustomize/overlays/production`)

- Sets `replicas: 3`
- Exposes service via Ingress with hostname and TLS annotation
- Uses a patched image from private ECR
- Applies Ingress resource (`prod-devops-ingress`)
- Enables HPA (CPU target ≥ 50%)

## 3. Horizontal Pod Autoscaler

Introduced `HorizontalPodAutoscaler` for production overlay:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: devops-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: devops-api
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

## 4. Ingress with TLS (Production)

Configured production Ingress with the following:

- TLS annotations (supports self-signed or cert-manager)
- Host-based routing for `prod-devops-api.local`
- Path forwarding to the service on `/`

## 5. Config Validation

Used `kubeval` to validate generated manifests:

```bash
kustomize build kustomize/overlays/production | kubeval --strict --ignore-missing-schemas
```

All base and overlay resources validated successfully (some skipped due to unsupported schemas like Ingress and HPA).

## 6. Git Version Control and Branching

All changes were committed to a dedicated feature branch:

```bash
git checkout -b feature/k8s-kustomize-phase-4
git add .
git commit -m "feat: k8s deployment with kustomize, HPA, Ingress, and NetworkPolicy for Phase 4"
git push origin feature/k8s-kustomize-phase-4
```

A pull request will be submitted to merge this work into `main`.

## Summary

Phase 4 has successfully introduced a secure, scalable Kubernetes deployment using Kustomize. The application is now deployable in both local and production environments, with automated scaling, config injection, pod security enforcement, and cluster-ready Ingress routing. This lays the groundwork for monitoring, logging (e.g., FluentBit), and production-grade CI/CD workflows in subsequent phases.
