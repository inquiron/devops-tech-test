# Phase 3 – CI/CD Pipeline with GitHub Actions (Build, Scan, and Push to ECR)

This document outlines the implementation of **Phase 3** of the DevOps Technical Test. The objective of this phase was to automate the container image build, security scanning, and publishing process to Amazon Elastic Container Registry (ECR) using GitHub Actions.

## Objectives Completed

- Developed a secure and efficient GitHub Actions CI/CD pipeline (`publish.yml`)
- Integrated pre-push vulnerability scanning using Trivy and Syft
- Configured GitHub OIDC integration with AWS IAM for credential-free authentication
- Automatically created the ECR repository (if not existing) to support idempotent workflows
- Successfully pushed the tagged Docker image to a private ECR repository
- Added a dedicated pre-PR scanning workflow (`pre-pr.yml`) for code quality and security
- Introduced a push-time code scan (`code-scan.yml`) for additional defence-in-depth

## 1. CI/CD Workflow Structure

A new pipeline was added under `.github/workflows/publish.yml`, triggered on pushes to the `main` branch. It includes the following key steps:

- Checkout code and install Node.js using `.tool-versions`
- Cache and install Node.js dependencies via `npm install`
- Run `npm audit` to detect vulnerabilities in third-party packages
- Build a Docker image using the secure Dockerfile from Phase 2
- Scan the built image with **Trivy** for CVEs
- Generate a full **SBOM** using Syft
- Upload audit reports to GitHub Actions as downloadable artifacts
- Authenticate to AWS via GitHub OIDC and assume a dedicated IAM role
- Conditionally create an ECR repository if missing
- Tag and push the image to ECR using the Git SHA

## 2. GitHub OIDC Integration

OIDC was configured by:

- Registering GitHub as an **OpenID Connect provider** in AWS IAM
- Creating a role with permissions to authenticate via OIDC and push to ECR
- Restricting the trust relationship to only allow `repo:CloudFred1010/devops-tech-test:ref:refs/heads/main`
- Using `aws-actions/configure-aws-credentials@v4` in the pipeline to assume the role

## 3. Pre-PR Workflow (`pre-pr.yml`)

A security-first workflow was introduced to scan pull requests before merging:

- Triggers on any PR to `main`
- Installs dependencies, lints code, runs `npm audit`
- Performs Trivy filesystem scan to detect exposed secrets or known risks
- Uploads the scan result (`trivy-fs-scan.txt`) as an artifact

## 4. Push-Time Scan Workflow (`code-scan.yml`)

A lightweight scan is also triggered on all pushes to `main` and `feature/*`:

- Performs code linting and `npm audit`
- Runs Trivy filesystem scan on the app directory
- Helps detect regressions and insecure commits post-merge

## 5. Git Operations

All workflow changes were committed on a dedicated CI branch:

```bash
git checkout -b ci/pipeline-phase-3
git add .
git commit -m "feat: add secure CI pipeline with scan and push to ECR"
git push origin ci/pipeline-phase-3
```

A pull request was submitted to merge into `main` after passing scans.

## Summary

The project now has a production-ready, security-conscious CI pipeline that enforces image scanning **before deployment** and integrates GitHub with AWS in a secure, scalable way. It lays the groundwork for Kubernetes deployments and GitOps-based automation in the next phase.
