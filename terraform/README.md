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

This assumes you have:
	•	An EKS cluster running
	•	Proper AWS credentials
	•	kubectl context set to the EKS cluster

Configure AWS/EKS

aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
kubectl get nodes

▶️ Deploy

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

📌 Multi-environment Deploy

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
