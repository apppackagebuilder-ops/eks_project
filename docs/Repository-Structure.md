# Repository Structure

This document explains every major folder in the repository like a classroom walkthrough.

## Top-level structure

```text
e:/eks_project
|-- README.md
|-- Jenkinsfile
|-- terraform/
|-- microservices/
|-- helm/
|-- helm-values/
|-- kubernetes/
|-- argocd/
|-- jenkins/
|-- scripts/
`-- docs/
```

## Why this structure exists

Real enterprise repositories separate concerns so different teams can work without stepping on each other.

- Infrastructure teams work mostly in `terraform/`.
- Platform teams work in `kubernetes/`, `helm/`, and `argocd/`.
- Application teams contribute to `microservices/`.
- CI/CD owners manage `Jenkinsfile`, `jenkins/`, and parts of `scripts/`.
- Trainers, operators, and beginners depend on `docs/`.

## Folder-by-folder explanation

## `terraform/`

This folder contains all infrastructure-as-code.

- `terraform/bootstrap/global/`
  Why it exists: creates the remote Terraform backend resources such as S3 and DynamoDB.
  What problem it solves: prevents local state drift and supports team-safe state locking.

- `terraform/environments/dev/`
  Why it exists: composes modules into a deployable development environment.
  What problem it solves: keeps environment-specific values separate from reusable modules.

- `terraform/environments/dev-addons/`
  Why it exists: deploys Kubernetes and AWS-integrated add-ons after the EKS cluster exists.
  What problem it solves: separates cluster creation from cluster customization.

- `terraform/modules/networking/`
  Why it exists: reusable network baseline.
  What problem it solves: avoids copy-paste VPC code across environments.

- `terraform/modules/eks/`
  Why it exists: reusable EKS cluster definition.
  What problem it solves: standardizes control plane, node groups, IAM, and OIDC setup.

- `terraform/modules/eks-addons/`
  Why it exists: reusable add-on installation logic.
  What problem it solves: packages IRSA roles and Helm releases for common EKS add-ons.

- `terraform/modules/storage/`
  Why it exists: reusable EFS storage layer.
  What problem it solves: gives workloads shared persistent storage without re-creating EFS logic each time.

## `microservices/`

This folder contains the demo business applications.

- `user-service/`
  Returns user records.
- `product-service/`
  Returns product catalog data.
- `order-service/`
  Calls several other services to create an order.
- `payment-service/`
  Stores payment data in SQLite on persistent storage.
- `notification-service/`
  Records simulated notification events.
- `frontend-ui/`
  Shows data from all backend services in one simple web page.

Each microservice folder contains:

- `app/`: application source code.
- `requirements.txt`: Python dependencies.
- `Dockerfile`: build instructions for the container image.

## `helm/`

This folder contains reusable Helm charts.

- `helm/platform-stack/`
  Why it exists: packages all application Kubernetes resources into a versioned chart.
  What problem it solves: lets the same app stack deploy cleanly to dev, qa, stage, and prod with different values files.

## `helm-values/`

This folder contains externalized Helm values for third-party charts.

- `helm-values/jenkins/`
  Values for the Jenkins Helm chart.
- `helm-values/argocd/`
  Values for the ArgoCD Helm chart.
- `helm-values/observability/`
  Values for Prometheus, Loki, Fluent Bit, and related tooling.

Why separate these from the charts:

- You can keep vendor charts unchanged.
- You can version only your environment-specific settings.
- Upgrades become easier because you do not fork upstream charts.

## `kubernetes/`

This folder stores raw Kubernetes manifests that are useful for training or direct GitOps application.

- `kubernetes/core/`
  RBAC and ReplicaSet training examples.
- `kubernetes/security/`
  Pod Security Standards and baseline network policy.
- `kubernetes/storage/`
  StorageClasses and PV/PVC examples.
- `kubernetes/ingress/`
  ALB and NGINX ingress examples.
- `kubernetes/certificates/`
  cert-manager issuers and certificate objects.
- `kubernetes/observability/`
  Prometheus rules, dashboards, and logging examples.
- `kubernetes/karpenter/`
  Karpenter capacity configuration.

## `argocd/`

This folder stores GitOps application definitions.

- `argocd/projects/`
  Defines ArgoCD project guardrails.
- `argocd/bootstrap/`
  Contains the root application for the App of Apps pattern.
- `argocd/apps/dev|qa|stage|prod/`
  Contains environment-specific child applications.

Why organizations use this structure:

- It is easy to promote the same app stack across environments.
- You can reason about each environment independently.
- ArgoCD can self-heal from Git in a predictable way.

## `jenkins/`

This folder stores Jenkins-specific assets.

- `jenkins/shared-library/`
  Reusable pipeline steps.
- `jenkins/casc/`
  Jenkins Configuration as Code definitions.

Why it exists:

- Shared libraries reduce duplicate pipeline code.
- JCasC makes controller setup reproducible and versioned.

## `scripts/`

This folder contains helper automation used by humans or CI/CD.

- Validation scripts.
- Helm value update helpers.

## `docs/`

This folder is the training manual for the repository.

- Architecture explanations.
- Step-by-step setup guides.
- Operations and troubleshooting runbooks.
- Interview preparation.
- Demo walkthroughs.
- Phase-by-phase instruction.

## How this mirrors a real organization

In a real enterprise setup, one repo may be split into multiple repos later, but the responsibility boundaries remain similar. Networking, platform engineering, GitOps, CI/CD, workloads, and documentation still need clear ownership and predictable interfaces.
