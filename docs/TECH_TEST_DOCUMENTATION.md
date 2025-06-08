# DevOps Tech Test Documentation
* This project demonstrates the full DevOps lifecycle including:
* Dockerizing a Node.js API
* Implementing CI/CD with GitHub Actions
* Vulnerability scanning with Trivy and CodeQL
* Kubernetes deployment using Kustomize with overlays for staging and production
* Infrastructure provisioning using Terraform (works for both local and AWS EKS)
* Secure secrets handling with AWS Secrets Manager
* Ensuring best practices in automation, maintainability, and security


### PROJECT STRUCTURE
.
├── .github/
│   └── workflows/
│       ├── ci-pipeline.yml           # CI for testing and checks
│       ├── trivy-scan.yml            # Trivy vulnerability scanning
│       ├── publish.yml               # Builds and pushes to ECR
│       ├── deploy.yml                # Terraform deployment
│       ├── codeql-scan.yml           # Static code analysis
│   ├── CODEOWNERS
│   └── pull_request_template.md
├── app/                              # Node.js API source
│   ├── config/
│   ├── src/
│   └── ...
├── kustomize/
│   ├── base/
│   └── overlays/
│       ├── local/
│       └── production/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Dockerfile                        # Production Dockerfile
├── Dockerfile.dev                    # Development Dockerfile
├── .tool-versions                    # ASDF tool versions
└── README.md

# Dockerization

### Goals Met:

- Production-ready image
- Small, minimal final image (dist + npm ci --omit=dev)
- Vulnerability scanned using Trivy
- Multi-stage build with layer caching
- Non-root user and secure permissions

### Production Image

Multi-stage build (`Dockerfile`):

- **Stage 1**: Build TypeScript
- **Stage 2**: Copy only `dist/` and pruned `node_modules`
- **Final**: Runs on `node:18-alpine`, non-root user

### Security
- Trivy integrated into CI (trivy-scan.yml)
- CodeQL static analysis (codeql-scan.yml)
- Runtime uses non-root user for security
- Google API Key securely fetched via AWS Secrets Manager
- Caching layers enabled
- Minimal attack surface

# CI/CD with GitHub Actions
### Workflows Overview
| Workflow             | Description                              |
|----------------------|------------------------------------------|
| `cicd-pipeline.yml`  | CI/CD Pipeline                 |
| `trivy-scan.yml`     | Docker image vulnerability scan         |
| `codeql-scan.yml`    | Static analysis on code                 |
| `publish.yml`        | Build & push to ECR (staging/main)      |
| `deploy.yml`         | Terraform apply & deployment            |


### Workflow
1. **ci-pipeline.yml** – Code Validation
* Triggered: On every push or pull request.

2. trivy-scan.yml – Docker Vulnerability Scan
* Triggered: On every push or PR.
    Steps:
        - Build Docker image using the development or production Dockerfile.
        - Run Trivy scan on the built image.
        - Fail the workflow if critical vulnerabilities found.
* Goal: Detect security vulnerabilities early in the container image.

3. codeql-scan.yml – Static Analysis
* Triggered: On every push or PR.
    Steps:
        - Initialize CodeQL database.
        - Analyze the codebase with CodeQL queries.
* Goal: Identify potential security risks and bugs in source code.

4. publish.yml – Build and Publish Docker Images
* Triggered: On push to:
        main branch (production)
        Feature branches matching feature/* (staging)
    Steps:
        - Checkout code.
        - Login to AWS ECR.
        - Build a multi-stage Docker image:
        - Uses Dockerfile for production.
        - Optimizes for small image size with layer caching.
    Tag image with:
        - Branch name (feature-xyz, main)
    Push image to ECR.
    Create ECR repository if it does not exist (idempotent).
* Goal: Publish secure, optimized images tagged for deployment.

### Branching Strategy
* Feature branches deploy to staging
* Main branch deploys to production

### Secrets & Credentials Handling
* No secrets in code or plaintext
* Centralized secret storage via AWS Secrets Manager
* GitHub Secrets reused across CI/CD workflows
* Secrets injected into Kubernetes using kustomize patches
* IAM user devsec-cicd with least-privilege policy for:
    - ECR
    - EKS
    - SecretsManager
    - S3
    - IAM

### Verification
To verify or rotate secrets:
    - Update in AWS Secrets Manager
    - Redeploy using GitHub Actions (deploy.yml)

### Secret Used
| Secret Name             | Usage                                |
|--------------------------|---------------------------------------|
| `AWS_ACCESS_KEY_ID`      | Access for CI/CD pipelines            |
| `AWS_SECRET_ACCESS_KEY`  | Access for CI/CD pipelines            |
| `AWS_REGION_CI`          | Region to target for ECR/EKS          |
| `AWS_SECRET_NAME`        | Name of AWS secret for Google Key     |
| `EKS_CLUSTER_NAME`       | Used in deploy pipeline               |
| `KUBE_CONFIG`            | Base64 kubeconfig if needed           |
| `GOOGLE_KEY`             | Stored in AWS Secrets Manager         |


# Kubernetes with Kustomize

### Directory structure
kustomize/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── local/
│   │   ├── patch-env.yaml
│   │   └── kustomization.yaml
│   └── production/
│       ├── patch-env.yaml
│       └── kustomization.yaml

### Features
- Environment-specific values via patch-env.yaml
- secretGenerator used for injecting secrets:
    - **APP_PORT**
    - **GOOGLE_KEY**
- HPA configured for 50% CPU usage
- Base manifests include deployment.yaml, service.yaml, hpa.yaml
- overlays/local: Uses local values and fake secrets
- overlays/production: Uses real image, secretGenerator for google-key, and different replica count

# Terraform (Infrastructure as Code)

# Directory Structure
terraform/
├── main.tf
├── variables.tf
└── outputs.tf

### Features
* Supports both local and remote deployments
* Dynamically applies correct overlay using kustomization
* Integrated into GitHub Actions deploy pipeline
* main.tf: Defines AWS provider, IAM, ECR, EKS resources
* variables.tf: Central config for different environments
* outputs.tf: Outputs important resource values
* Used ENV variables to switch between local/prod


Notes
All steps are reproducible using asdf, GitHub Actions, and Terraform.
Follows DevOps best practices: automation, security, idempotency, least privilege, immutability.
Uses real-world production patterns (ECR, EKS, Kustomize overlays, AWS Secrets Manager).

# Summary
This project covers a complete DevOps lifecycle:
🐳 Dockerization with secure builds
🤖 Automated CI/CD pipelines
☸️ Kubernetes manifests with Kustomize
🛡️ Security scanning using Trivy & CodeQL
☁️ Infrastructure as Code using Terraform
🔐 Secrets managed via AWS Secrets Manager