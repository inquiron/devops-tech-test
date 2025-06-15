### Describe your changes

1. Docker
Created a multi-stage Dockerfile at the project root.

Used node:18-alpine for both builder and runtime stages.

Performed steps to install only production dependencies:
RUN npm ci --omit=dev

Compiled the TypeScript source code in the builder stage and copied only necessary artifacts (dist/, node_modules/, package.json) to the final image.

Set a non-root user (appuser) and appropriate permissions for security.

Defined a proper CMD to run the app:
CMD ["node", "dist/index.js"]

Security & Performance
Used minimal Alpine base for smaller image size and fewer vulnerabilities.

Used tini to allow clean shutdown with SIGINT.

Verified vulnerabilities using tools like docker scan or trivy.

2. CI
Created .github/workflows/publish.yml.

Triggered on every push to main.

Configured AWS credentials using GitHub OIDC:
permissions:
  id-token: write
  contents: read

Used aws-actions/configure-aws-credentials@v2 to assume a role.

Added step to create ECR repository idempotently:  
aws ecr describe-repositories || aws ecr create-repository

Built and pushed Docker image to ECR using docker/build-push-action@v5.

Version Tagging
Added version tags based on GITHUB_SHA or git describe.

3. Kubernetes
Structured K8s config under kustomize/:
kustomize/
  └── base/
  └── overlays/
      ├── local/
      └── production/

Declared resources: Deployment, Service, HPA, Secret.

Added health checks on /healthz.

Made app highly available via replicas and HPA:
minReplicas: 2
maxReplicas: 5
targetCPUUtilizationPercentage: 50

Used kustomize edit fix to upgrade deprecated syntax (patchesStrategicMerge → patches).

Exposed the service via NodePort locally and documented the need for ingress in production.

APP_PORT and SECRET_KEY are injected as environment variables.

Managed SECRET_KEY via Kubernetes Secret, not hardcoded.

Add-ons and Requirements
Assumes Docker Desktop for local cluster.

Steps documented for enabling ingress in production (e.g., NGINX controller).

4. Deployment
Wrote terraform/ structure:
main.tf, provider.tf, locals.tf, outputs.tf, variables.tf

Used a null_resource with local-exec provisioners to apply Kustomize overlays:
command = "kubectl apply -k ../kustomize/overlays/${self.triggers.environment}"

Supported both local and production environments using a var.environments list.

Created a tfvars file for local and production deployment.

Output variable to show which environment was deployed.

Support for Both Local and Production
For local:
	•	Uses kubeconfig from Docker Desktop.
For production:
    •	Uses kubeconfig from Docker Desktop.
	•	Requires AWS EKS cluster and kubeconfig.
	•	Updates to provider "kubernetes" with kubeconfig_path or cluster_ca_certificate, token, etc.

### Document any other steps we need to follow

Deployment Guide: Local & Production

This document outlines how to deploy the application using Terraform + Kustomize to both local and production Kubernetes environments.

⸻

 Prerequisites

Ensure the following tools are installed and configured:
	•	asdf with plugins:

asdf install


	•	kubectl
	•	kustomize
	•	terraform
	•	docker
	•	aws CLI (for production)

⸻

 Local Deployment

This targets a local Kubernetes cluster (e.g., Docker Desktop).

Deploy

cd terraform
terraform init
terraform apply -var-file=environments/local.tfvars

This will:
	•	Apply the kustomize/overlays/local manifests
	•	Deploy the app, secret, service, HPA, and deployment

 Destroy

terraform destroy -var-file=environments/local.tfvars

This will delete the local Kustomize deployment.

⸻

Production Deployment
This targets a local Kubernetes cluster (e.g., Docker Desktop).

This also assumes you have:
	•	An EKS cluster running
	•	Proper AWS credentials
	•	kubectl context set to the EKS cluster

Configure AWS/EKS

aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
kubectl get nodes

Deploy

cd terraform
terraform apply -var-file=environments/production.tfvars

 Destroy

terraform destroy -var-file=environments/production.tfvars


⸻

Terraform Structure

File	Purpose
main.tf	Defines the null_resource to run kubectl against overlays
locals.tf	Constructs dynamic overlay paths
variables.tf	Declares environment variables
outputs.tf	Outputs current environment deployed
environments/*.tfvars	Per-environment configuration


⸻

Multi-environment Deploy

To deploy both environments in one go:
	1.	Create environments/all.tfvars:

environments = ["local", "production"]


	2.	Run:

terraform apply -var-file=environments/all.tfvars



⸻

Notes
	•	Kustomize overlays live under:
	•	kustomize/overlays/local/
	•	kustomize/overlays/production/
	•	SECRET_KEY is handled securely via Kubernetes secrets.
	•	Health checks target the /healthz endpoint.
	•	The setup ensures high availability and includes HPA for scalability.

⸻

### Checklist before requesting a review

- [ ] I have performed a self-review of my code.
- [ ] I have included any documentation relevant to review my changes.
