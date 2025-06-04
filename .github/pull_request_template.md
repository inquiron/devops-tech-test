### Describe your changes

1. Docker

Created a Dockerfile to containerise the application. 
- Used base image `node:22.16.0-alpine3.21` which is slim and has no vulns.
- Reduced the size of the image by using multi-stage build. 
- Scanned the image and the code with [trivy](https://github.com/aquasecurity/trivy?tab=readme-ov-file). 
  - Found 2 vulns affecting two packages: formidable and koa, it will be suggested to upgrade the versions in the `package.json` as follows: "formidable": "^2.1.3", "koa": "^2.16.1".
- Took advantage of cache layers by installing package.json and its dependencies first (which are the slowest).
- Ensured the user had no write access to the container.


2. CI

- Built a GA pipeline to publish the image into AWS ECR.
  - Optimised pipeline execution time by caching the Docker layers from previous executions. Ref https://docs.docker.com/build/ci/github-actions/cache/#local-cache
  - There is a step to create an ECR but when it fails because exists, the pipeline continues.

3. Kubernetes

- Deployed an application in a Kubernetes Cluster.
  - Used kustomize overlays to customise each env.
  - Created a manifest for each resource. 
  - Generated secrets from a file using kustomize.
  - Annotated the service to allow traffic from the internet. Ref [annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/service/annotations/#service-annotations)


4. Deployment

- Manage Kubernetes resources using Terraform. 
  - Created variable:
    - To connect to cluster.
    - To specify the environment (local, prod)
    - To specify the secret ( GOOGLE_KEY )
  - Define resources similar to kustomize but using Terraform syntax.


### Document any other steps we need to follow

Useful commands to test new code

See kustomize resources
```
kubectl kustomize kustomize/local
```

Apply local
```
kubectl apply -k kustomize/local
```

Apply prod
```
kubectl apply -k kustomize/prod
```

#### For terraform

To test it
1. create .tfvars with the variables (using the target cluster)
1. Run `terraform apply -f .tfvars`


### Checklist before requesting a review

- [ x ] I have performed a self-review of my code.
- [ x ] I have included any documentation relevant to review my changes.
