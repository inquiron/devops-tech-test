# DevOps Tech Test

We think infrastructure is best represented as code, and provisioning of resources should be automated as much as possible.

We are testing your ability to implement modern automated infrastructure, as well as general knowledge of system administration and coding. In your solution you should emphasize readability, maintainability and DevOps methodologies.

To begin the test:

1. Clone this repository and start adding your changes.
2. Commit often, we would rather see a history of trial and error than a single monolithic push.
3. When you're finished open a PR and let us know it is ready for review.
4. Please ensure you include all steps taken to get your solution running so that we can reproduce predictably.

## Pre-requisites

### ASDF

To ensure that the project runs the same on your machine as well as ours, we encourage you to use [`asdf`](https://asdf-vm.com/). We will be reviewing your work using `asdf` to execute CLI commands, so please ensure you keep this file updated with CLI tools and versions that you use to ensure we share the experience you intend for us.

### Docker & Kubernetes

This project requires you to use Docker and have a local Kubernetes cluster. We recommend you use [Docker Desktop](https://www.docker.com/products/docker-desktop/), but there are other tools you can use if you wish. We will be using Docker Desktop and Kubernetes that ships with it to review your changes, but if you are going to use other tooling please provide the steps you took to setup including an extensions, plugins or tooling you use.

### Setup

If you are using `asdf` you can install the dependencies with the following:

```bash
asdf plugin add nodejs
asdf plugin add kustomize
asdf install
```

---

## 1. Docker

The team currently deploy an API onto a Virtual Machine (VM) and run the Node process directly on the VM. This has caused some unpredictable behaviour from running on the engineer's local machines vs running the application remotely on a VM. In order ensure the application runs consistently on all machines the team have elected to Dockerise the application, but haven't written a Dockerfile before and have asked for you to create them a boilerplate example that incorporates best practices when writing Dockerfiles.

The team have given you the following instructions:

### Running the application

To run the API in `development` mode:

```bash
cd app
npm i
npm start
```

To run the API in `production` mode:

```bash
cd app
npm i
npm run compile
node dist/index.js
```

_You should replicate similar steps to production in the provided Dockerfile. Do not create a separate Dockerfile_

You can check the application is running with

```bash
curl http://localhost:90002/hello

# OR

curl http://localhost:90002/hello?name=Joe

# OR the health check endpoint

curl http://localhost:9002/healthz
```

### Production application files

All transpiled files that are needed to run the application in a production environment is in the `dist/` directory along with the `node_modules` available after running `npm i --omit dev` for the first time (i.e. `node_modules` directory does not already exist).

### Task

- Update the provided `Dockerfile` located in the root of the project for the application that is in the `app/` directory.
- Ensure the Docker build process effectively utilises cache layers to minimise the steps to rebuild image when changes are introduced.
- Ensure runtime image is as small as possible and has minimal or no vulnerabilities. (We are keen to be able to reproduce your steps for detecting vulnerabilities so please document how you verified image vulnerabilities)
- Ensure the image is secure by setting permissions correctly include ownership.
- Determine appropriate entrypoint and/or command for the running image.

### What we are looking for

- Production-ready application image
- Image size
- Image vulnerabilities
- Image security
- Docker layer caching

### Extra Credit

- Can kill node process with SIGINT without changes to source code

## 2. CI/CD

The team would like to setup a CI pipeline to build and publish the Docker image to ECR in the businesses AWS account. The team want to use Github Actions to do this.

### Task

- Write a CI pipeline in `.github/workflows/publish.yml`
- Trigger the publish pipeline when a commit is pushed on `main`
- Minimise the pipeline run time as much as possible

### Extra Credit

- Idempotently create the ECR repository as part of the publish pipeline if it does not already exist, or fail silently and continue if it already exists

## 3. Kubernetes

The team want to deploy the application to a Kubernetes cluster. They would like to expose the service to external traffic. Write the Kubernetes resources to run the application Pods and expose the application to external ingress traffic.

### Task

- Utilise [Kustomize](https://kustomize.io/) to create a base and overlays for local and production
- Write Kubernetes resources in `kustomize` directory.
- Set and inject `APP_PORT` and `SECRET_KEY` environment variables for Pods
- Ensure `SECRET_KEY` is managed as sensitive information - you can set this to any value for the purpose of this test. We mainly want to see that you know best practices for keep secure information from leaking.
- Ensure the application is highly available
- Ensure application is exposed outside the cluster in both local and production setups
- Provide steps to create and install required extensions to the cluster
- Use the `/healthz` endpoint in your Pod health checks

### Extra Credit

- Do not use any templating tools such as Helm
- Horizontal Pod Autoscaling - ensure the pod can scale based on CPU utilisation of 50%

## 4. Terraform

The team want to automate the deployment process. They would like you to write the Terraform that will deploy the application resources from Task 3 to a target Kubernetes cluster. This should work for both local and remote Kubernetes clusters so it can be used to deploy and run locally as well as to a remote environment.

### Task

- Write Terraform to deploy the application resources in `kustomize/` directory to a Kubernetes cluster
- Ensure the Terraform can be used for both local and remote deployments
- Set environment-specific variables depending on target environment, i.e. local or production
- Provide steps for the team to trigger the deployment themselves for both local and production

### Extra Credit

- Provision and utilise a service to manage applying the kustomization in the cluster
