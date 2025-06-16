# Phase 1 – Project Setup and Environment Preparation

This document outlines the complete setup and configuration process undertaken during Phase 1 of the DevOps Technical Test. The goal of this phase is to ensure a reproducible, secure, and consistent development environment aligned with DevOps and DevSecOps practices.

## Objectives Completed

- Initialised Git and enforced `.gitignore` hygiene
- Installed and configured ASDF for tool version control
- Installed and validated Docker, Kubernetes, and essential CLI tools
- Configured pre-commit hooks for code quality and consistency
- Implemented secret scanning with `git-secrets`
- Performed initial container vulnerability scanning using Trivy
- Validated application startup locally

---

## 1. Repository Setup

```bash
git clone https://github.com/<org>/<repo-name>.git
cd <repo-name>
git checkout -b setup/environment
```

---

## 2. Git Initialisation and .gitignore Hygiene

Ensured Git was initialised and the `.gitignore` includes:

```
node_modules/
.env
.terraform/
terraform.tfstate*
*.pem
security_scan.txt
```

---

## 3. Toolchain Setup with ASDF

ASDF was configured to ensure consistent CLI tool versions:

```bash
asdf plugin add nodejs
asdf plugin add kustomize
asdf plugin add terraform
asdf plugin add kubectl
asdf plugin add awscli
asdf install
```

Created and committed `.tool-versions`:

```
nodejs 20.11.1
kustomize 5.3.0
terraform 1.8.4
kubectl 1.30.0
awscli 2.16.1
```

---

## 4. Tool Validation

Verified the installed tool versions:

```bash
docker version
kubectl version --client
terraform version
asdf current
```

---

## 5. Pre-Commit Hook Setup

Configured `pre-commit` with the following hooks:

- `pre-commit-hooks`: trailing whitespace, end-of-file fixer, large file check
- `yamllint`: YAML linting
- `eslint`: JS linting via `mirrors-eslint`
- `prettier`: local formatter for JS, TS, YAML, Markdown

Installed and ran the hooks:

```bash
pre-commit clean
pre-commit autoupdate
pre-commit install
pre-commit run --all-files
```

Confirmed all checks passed.

---

## 6. Secret Scanning

Installed and configured `git-secrets`:

```bash
brew install git-secrets
git secrets --install
git secrets --register-aws
```

Optionally installed and documented TruffleHog:

```bash
brew install trufflehog
trufflehog git --repo .
```

---

## 7. Container Vulnerability Scanning

Installed Trivy and performed a baseline scan:

```bash
brew install aquasecurity/trivy/trivy
trivy version
trivy fs . > security_scan.txt
```

Excluded `security_scan.txt` from version control.

---

## 8. Application Validation

Started and validated the Node.js API locally:

```bash
cd app
npm install
npm start
curl http://localhost:9002/hello
```

Confirmed expected output was returned.

---

## 9. Commit Phase 1 Changes

Finalised and committed all Phase 1 work:

```bash
git add .
git commit -m "Phase 1 complete: Project setup, ASDF version control, security scanning, and local app validation"
```

---

## Summary

The environment is now secure, reproducible, and ready for containerisation and infrastructure automation. This foundation sets the stage for future implementation phases, promoting reliability, consistency, and security from the beginning of the project.
