## ✅ Kubernetes Deployment Overview

This document confirms the completion of Task 3 - Kubernetes, as outlined in the DevOps Technical Test.

---

###  Resource Structure

* **Base configuration:**

  * Located at: `kustomize/base`
* **Overlays:**

  * Local: `kustomize/overlays/local`
  * Production: `kustomize/overlays/production`

---

###  Features Implemented

| Requirement                                                 | Status | Notes                                                            |
| ----------------------------------------------------------- | ------ | ---------------------------------------------------------------- |
| Use of [Kustomize](https://kustomize.io/) base and overlays | ✅ Done | Reusable structure via base and overlays                         |
| Kubernetes resources defined in `kustomize/`                | ✅ Done | Deployment, Service, Secret, and HPA included                    |
| Inject `APP_PORT` and `SECRET_KEY` as environment variables | ✅ Done | `APP_PORT` via env, `SECRET_KEY` via Kubernetes Secret           |
| Secure management of `SECRET_KEY`                           | ✅ Done | Stored as Secret, not exposed in plaintext                       |
| Ensure high availability                                    | ✅ Done | Multiple replicas defined in Deployment                          |
| Expose application to external traffic                      | ✅ Done | Service is `LoadBalancer` for both environments                  |
| Use `/healthz` for pod liveness and readiness probes        | ✅ Done | Configured in base deployment manifest                           |
| Provide steps to install cluster extensions                 | ✅ Done | Metrics Server required for HPA; instructions in `deployment.md` |
| Horizontal Pod Autoscaling at 50% CPU utilization           | ✅ Done | HPA resource defined in base                                     |

---

###  Notes

* **Local environment:**

  * Uses Docker Desktop with Kubernetes enabled.
  * Apply with: `kubectl apply -k kustomize/overlays/local`

* **Production environment:**

  * Uses Docker Desktop with Kubernetes enabled and Requires EKS cluster and configured kubeconfig if needed to be tested in AWS
  * Apply with: `kubectl apply -k kustomize/overlays/production`

---

###  Cluster Extensions (Prerequisites)

Ensure the following are installed in the cluster:

1. **Metrics Server** (for HPA)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

2. **Ingress Controller** (optional if you want Ingress-based routing)

3. **Docker Desktop Users:** No additional setup required beyond enabling Kubernetes.

---

All Kubernetes features requested in the assignment have been successfully implemented and tested.
