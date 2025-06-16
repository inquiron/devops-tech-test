# Phase 2 – Dockerising the Node.js Application (Securely)

This document outlines the implementation of Phase 2 of the DevOps Technical Test. The objective of this phase was to securely containerise the Node.js application using modern Docker practices and to lay the foundation for reliable deployment and automation workflows.

## Objectives Completed

- Created a secure, multi-stage Dockerfile
- Enforced non-root execution with least privilege access
- Incorporated a healthcheck endpoint (`/healthz`)
- Built and validated the container locally using Docker Compose
- Conducted a vulnerability scan using Trivy
- Generated a full SBOM (Software Bill of Materials) using Syft
- Exported scan output (`docker_scan.txt`) and SBOM (`sbom.json`) for audit reference
- Committed all changes on a dedicated branch and pushed to remote GitHub repository

## 1. Secure Dockerfile Configuration

A production-grade, multi-stage `Dockerfile` was added at the root of the repository with the following structure:

- **Build stage:** Uses `node:18-alpine` to install dependencies and transpile TypeScript
- **Runtime stage:** Uses `gcr.io/distroless/nodejs:18` for minimal surface area and improved security
- **Security hardening:**
  - Sets `WORKDIR /app`
  - Uses `USER nonroot` to drop root privileges
  - Copies only required files (`dist/`, `node_modules/`, `config/`)
  - Reduces image size and enhances caching efficiency

## 2. Docker Compose for Local Validation

A `docker-compose.yml` file was introduced to simplify local deployment and maintain consistency:

```bash
docker compose build --no-cache
docker compose up
```

The container listens on port `9002`. Validation checks:

```bash
curl http://localhost:9002/hello
curl http://localhost:9002/hello?name=Joe
curl http://localhost:9002/healthz
```

Expected outputs were returned, confirming application health and routing.

## 3. Healthcheck Integration

A `HEALTHCHECK` directive was configured in `docker-compose.yml` to target the `/healthz` endpoint. This enables automated readiness checks for orchestration and CI/CD tools.

## 4. Vulnerability Scanning with Trivy

Trivy was installed and used to perform a security scan against the built image:

```bash
trivy image devops-tech-test-node-api > docker_scan.txt
```

This scan file serves as part of the audit trail. The scan reported no critical vulnerabilities due to the use of a distroless base image.

## 5. Generating a Software Bill of Materials (SBOM)

Syft was used to generate an SBOM detailing all packages and binaries within the image:

```bash
syft devops-tech-test-node-api -o json > sbom.json
```

This supports transparency, compliance, and supply chain risk management practices.

## 6. Git Version Control and Branching

All changes were committed to a dedicated branch, adhering to Git best practices:

```bash
git checkout -b setup/docker-ci-phase-2
git add .
git commit -m "feat: dockerised Node.js app with security scan and SBOM for phase 2"
git push origin setup/docker-ci-phase-2
```

A pull request will be submitted against `main` to merge the Phase 2 work upon approval.

## Summary

The application is now securely containerised with hardened runtime execution, a validated health endpoint, and security audit outputs. This foundation ensures a reliable and reproducible deployment pipeline and prepares the project for Kubernetes orchestration and CI/CD automation in the next phase.
