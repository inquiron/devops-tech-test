Changelog

Overview

This changelog documents the key changes made to implement the end-to-end DevOps pipeline, covering Docker, CI/CD, Kubernetes, and Terraform infrastructure as code.

⸻

Initial Implementation

Docker
	•	Created a production-ready Dockerfile using multi-stage build with node:18-alpine.
	•	Installed dependencies via npm ci --omit=dev for production.
	•	Compiled TypeScript application and copied only required files to final image.
	•	Added non-root appuser with correct ownership for container security.
	•	Used tini as the init process to handle graceful shutdown.
	•	Set the default CMD to node dist/index.js.
	•	Verified Docker image using docker scan and/or trivy.

⸻

App Config
    •   Updated app/config/config.js to:

    •   Read from environment variables with default fallbacks.
    •   Ensure the required SECRET_KEY is read from the environment and used securely.
    •   Exclude development-only settings from production build.
    
⸻

CI/CD (GitHub Actions)
	•	Added .github/workflows/publish.yml:
	•	Triggered on push to main.
	•	Configured OIDC-based AWS IAM authentication.
	•	Automatically created ECR repo if not present.
	•	Built and pushed image to ECR using docker/build-push-action.
	•	Tagged image with latest and short SHA.
	•	Optimized pipeline caching with BuildKit (cache-from and cache-to).

⸻

Kubernetes (Kustomize)
	•	Structured Kubernetes manifests under kustomize/:
	•	base/ for common resources.
	•	overlays/local and overlays/production for environment-specific overrides.
	•	Defined Deployment, Service, HPA, and Secret.
	•	Used /healthz endpoint for liveness and readiness probes.
	•	Used patches instead of deprecated patchesStrategicMerge.
	•	Injected APP_PORT and SECRET_KEY via environment variables.
	•	Managed SECRET_KEY securely using Kubernetes Secrets.
	•	Ensured high availability with 2 replicas and autoscaling at 50% CPU.
	•	Local deployment uses Docker Desktop Kubernetes.
	•	Production deployment assumes AWS EKS and ingress controller setup.

⸻

Terraform
	•	Created terraform/ directory with modular files:
	•	main.tf, provider.tf, variables.tf, outputs.tf, locals.tf.
	•	Used null_resource + local-exec to apply Kustomize overlays.
	•	Supported multi-environment deployment via var.environments.
	•	Applied overlays using kubectl apply -k.
	•	Defined .tfvars for local and production setup.
	•	Documented production usage to provide AWS EKS kubeconfig.
	•	Provided output indicating deployed environment.

⸻

Deployment Guides
	•	README.md in terraform directory explains setup for local and AWS-based production.
	•	README.md in kustomize directory includes extensions and health check configuration.

⸻

Future Improvements
	•	Replace null_resource with a custom provider or ArgoCD.
	•	Include Helm chart option as alternative.
	•	Add Terraform EKS provisioning.
	•	Add monitoring stack (Prometheus, Grafana) via manifests or Terraform.

⸻

Author
	•	Daniel David (DevOps Engineer)

⸻

Tags
	•	Docker, CI/CD, GitHub Actions, AWS ECR, Kubernetes, Kustomize, Terraform, DevOps