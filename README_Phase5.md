# Phase 5 – Infrastructure Automation with Terraform

This document explains the implementation of Phase 5 of the DevOps technical test, which focuses on automating Kubernetes resource deployment using Terraform. The configuration supports multiple environments, promotes reusability, and adheres to infrastructure-as-code best practices.

---

## What Was Implemented

### Terraform Structure

All Terraform files are organised for clarity and modularity:

- `main.tf`: Defines main resources and module calls.
- `variables.tf`: Declares global variables.
- `providers.tf`: Sets up required Terraform providers (Kubernetes and Null).
- `env/`: Contains environment-specific variable sets.
- `modules/app-secret/`: Encapsulated logic for managing Kubernetes secrets.

---

### Secure Secret Injection with Kubernetes

Secrets are managed using a custom module called `app-secret` located in:

`terraform/modules/app-secret/`

Inside `main.tf`, secret creation is conditionally applied only when the environment is not CI:

```hcl
count = var.env == "ci" ? 0 : 1
```

The secret value is injected as a base64-encoded Kubernetes Secret with type Opaque, keeping the sensitive data secure.

### Dynamic Deployment Using Null Resource and Kubectl

The deployment of Kubernetes manifests via Kustomize is triggered using a `null_resource`. This ensures the application of environment-specific overlays with every run.

```hcl
resource "null_resource" "apply_kustomize" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${var.kubeconfig_path} kubectl apply -k ${path.module}/../kustomize/overlays/${var.env} --validate=false"
  }

  triggers = {
    always_run = timestamp()
  }
}
```

This setup ensures Kubernetes manifests are applied consistently for each environment without manual intervention.

### Multi-Environment Support

Different environments are supported using `.tfvars` files. Examples:

`env/github.tfvars:`

```hcl
env             = "ci"
kubeconfig_path = "/dev/null"
secret_key      = "dev-secret-key"
```

`env/local.tfvars:`

```hcl
env             = "local"
kubeconfig_path = "~/.kube/config"
secret_key      = "your-local-secret-key"
```

This separation allows for targeted deployments across local, CI, and production setups.

### CI Validation

The CI pipeline is configured to:

- Run terraform init, validate, and plan
- Skip secret creation using environment gating
- Use the GitHub Actions runner with Terraform and AWS credentials
- Handle plugin and backend initialisation cleanly

This enables full visibility and safety in CI/CD without risk of leaking or applying production resources.

### How to Deploy

**Local Deployment**

Navigate to the Terraform directory and apply as follows:

```bash
cd terraform/
terraform init
terraform plan -var-file=env/local.tfvars
terraform apply -var-file=env/local.tfvars
```

**CI Deployment**

CI/CD pipelines will execute the following:

```bash
terraform plan -var-file=env/github.tfvars
```

This runs in GitHub Actions and is configured to avoid secret deployment in CI mode.

### Directory Structure Overview

```text
terraform/
├── main.tf
├── providers.tf
├── variables.tf
├── env/
│   ├── github.tfvars
│   └── local.tfvars
├── modules/
│   └── app-secret/
│       ├── main.tf
│       └── variables.tf
```

### Final Verification

The following elements have been implemented and verified:

- Terraform project structure is modular and reusable.
- Secrets are managed securely using a dedicated module.
- Kustomize overlays are applied through `kubectl apply -k` wrapped in a `null_resource`.
- Multi-environment deployment is achieved through separate `.tfvars` files.
- CI pipelines successfully validate Terraform without applying secrets.
- Manual and automated workflows are reproducible and reliable.

### Optional Enhancements (Future Work)

- Configure remote state backend using S3 and DynamoDB for production readiness.
- Apply `terraform fmt`, `terraform validate`, and `tflint` checks during CI.
- Add `kubectl rollout undo` rollback instructions in case of failed deployment.
- Conduct HPA stress tests to validate autoscaling.
- Provide documentation for onboarding new contributors and reproducibility.
