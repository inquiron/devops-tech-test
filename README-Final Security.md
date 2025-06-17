# DevOps Tech Test

![CI](https://github.com/CloudFred1010/devops-tech-test/actions/workflows/publish.yml/badge.svg)

## Project Overview

This repository demonstrates a complete DevOps implementation for a Node.js API service. It includes Dockerisation, continuous integration and delivery (CI/CD) using GitHub Actions, Kubernetes deployment via Kustomize, and infrastructure provisioning with Terraform. DevSecOps security best practices have been incorporated to meet enterprise-grade requirements, including CVE scanning, image signing, SBOM generation, and secret management.

---

## Key Implementations

### Phase 1 – Environment and Tooling Setup

- Cloned and set up the project using Git.
- Defined `.tool-versions` with ASDF to manage consistent versions of CLI tools (Node.js, Kustomize).
- Added `.gitignore` and `.dockerignore` to exclude unnecessary and sensitive files.
- Configured Prettier, ESLint, and pre-commit hooks to enforce code hygiene:
  - Trim trailing whitespace
  - Ensure EOF newline
  - Lint YAML files
- Verified with `pre-commit run --all-files`.

### Phase 2 – Dockerisation and Local Testing

- Created a multi-stage `Dockerfile` to build and run a secure, production-grade Node.js image.
- Included health check endpoints and secure configurations.
- Used `.dockerignore` to optimise build context and reduce image size.

### Phase 3 – CI/CD Pipeline (GitHub Actions)

- Developed a full CI pipeline (`.github/workflows/publish.yml`) to:
  - Set up Node.js using `actions/setup-node`
  - Cache and install dependencies (`npm install`)
  - Perform `npm audit` for dependency vulnerabilities
  - Run CVE scans using **Trivy**
  - Generate SBOM using **Syft**
  - Upload scan reports as GitHub Actions artefacts
  - Authenticate with AWS using OIDC (`configure-aws-credentials`)
  - Build and push image to Amazon ECR
  - Sign the image using **Cosign**
- Created `cosign-sign.yml` to test standalone signing and key decoding logic.

### Phase 4 – Kubernetes Deployment with Kustomize

- Created Kubernetes manifests for:
  - Deployment, Service, ConfigMap, and Secret
  - HorizontalPodAutoscaler (HPA)
  - Secure Pod `securityContext` settings (runAsNonRoot, readOnlyFS)
- Developed Kustomize overlays for local and production environments:
  - Local uses NodePort or localhost ingress
  - Production uses LoadBalancer with higher replica count
- Injected `APP_PORT` and `SECRET_KEY` via environment variables.
- Implemented `NetworkPolicy` to restrict internal pod traffic.
- Added `ServiceAccount` and RBAC binding to avoid use of default accounts.
- Enabled readiness and liveness probes.
- Defined `PodDisruptionBudget` to ensure minimum availability during disruptions.

### Phase 5 – Infrastructure Automation with Terraform

- Structured Terraform directories (`terraform/`) with:
  - `main.tf`, `variables.tf`, `outputs.tf`, `dev.tfvars`
- Implemented reusable modules and conditional logic (`count`, `enabled` flags).
- Added remote state backend configuration with S3 and DynamoDB.
- Validated Terraform configuration using `terraform fmt` and `terraform validate`.
- Ensured sensitive outputs are redacted using `sensitive = true`.

---

## DevSecOps Security Add-ons

- **CVE Scanning** with Trivy: Integrated directly into GitHub Actions pipeline.
- **Dependency Scanning** with `npm audit`: Automatically runs during CI.
- **Secret Scanning** with Gitleaks: `gitleaks detect --source=. --verbose` used.
- **Image Signing** with Cosign: Uses decoded base64 private key to sign pushed Docker images.
- **SBOM Generation** with Syft: Outputs SPDX-compliant `syft-sbom.json`.
- **YAML and Code Formatting**: All files linted with `yamllint` and Prettier.
- **Pre-commit Hooks**: Configured `.pre-commit-config.yaml` to run automated checks on commit.

---
