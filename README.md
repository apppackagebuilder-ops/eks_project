# Enterprise AWS EKS Platform Training Repository

This repository builds a production-style Amazon EKS platform in phases so a beginner can learn the full stack without guessing what comes next.

This repository now includes the end-to-end training scaffold for an enterprise-style Amazon EKS platform. The codebase covers:

- Terraform networking, EKS, add-ons, backend bootstrap, and shared storage.
- Six Python microservices plus a frontend UI.
- Helm charts and Kubernetes manifests.
- ArgoCD App of Apps GitOps configuration.
- Jenkins pipelines, shared libraries, and JCasC.
- Monitoring, logging, alerting, certificates, autoscaling, and security controls.
- Beginner-friendly documentation, troubleshooting, cost notes, demo scenarios, and interview preparation.

## Why this repository is structured like an enterprise project

Real organizations separate reusable building blocks from environment-specific configuration. That is why this repository starts with:

- `terraform/modules`: reusable modules.
- `terraform/environments`: deployable environments such as `dev`, `qa`, and `prod`.
- `docs`: beginner-friendly runbooks and architecture notes.
- `scripts`: repeatable helper commands.

## Current repository structure

```text
e:/eks_project
|-- README.md
|-- Jenkinsfile
|-- argocd
|-- helm
|-- helm-values
|-- jenkins
|-- kubernetes
|-- microservices
|-- docs
|   |-- Architecture.md
|   |-- Cost-Optimization.md
|   |-- Demo-Scenarios.md
|   |-- Deployment.md
|   |-- Execution-Guide.md
|   |-- Interview-Preparation.md
|   |-- Kubernetes-Internals.md
|   |-- Operations.md
|   |-- Platform-Architecture.md
|   |-- Requirement-Matrix.md
|   |-- Security.md
|   `-- Troubleshooting.md
|-- scripts
|   |-- phase1-validate.ps1
|   |-- update_helm_values.py
|   `-- phase1-validate.sh
`-- terraform
    |-- bootstrap
    |-- environments
    |   `-- dev
|   |   `-- dev-addons
    |       |-- main.tf
    |       |-- outputs.tf
    |       |-- providers.tf
    |       |-- terraform.tfvars
    |       |-- variables.tf
    |       `-- versions.tf
    `-- modules
        `-- networking
            |-- main.tf
            |-- outputs.tf
            |-- variables.tf
            `-- versions.tf
```

## Learning path

1. Start with [docs/Requirement-Matrix.md](docs/Requirement-Matrix.md) to see where every prompt requirement is implemented.
2. Read [docs/Platform-Architecture.md](docs/Platform-Architecture.md) and [docs/Kubernetes-Internals.md](docs/Kubernetes-Internals.md) for the conceptual model.
3. Read [docs/Repository-Structure.md](docs/Repository-Structure.md) to understand what each folder does.
4. Use [docs/Phase-by-Phase-Guide.md](docs/Phase-by-Phase-Guide.md) to work through the platform in the same sequence a trainer would teach it.
5. Use [docs/Execution-Guide.md](docs/Execution-Guide.md) for the exact setup commands.
6. Use [docs/Important-Code-Walkthrough.md](docs/Important-Code-Walkthrough.md) to understand the critical Terraform, Kubernetes, ArgoCD, and Jenkins code.
7. Use [docs/Demo-Scenarios.md](docs/Demo-Scenarios.md) to run the training demonstrations.
8. Use [docs/Interview-Preparation.md](docs/Interview-Preparation.md) to practice explaining the design.

## What Phase 1 solves

Without networking, EKS has nowhere to run. This phase creates the network boundary, routing behavior, address space, logging, and administrative access patterns needed before a cluster can exist.

## Fast start

1. Read `docs/Architecture.md` to understand the design.
2. Read `docs/Deployment.md` and install the required tools.
3. Review `terraform/environments/dev/terraform.tfvars` and change `bastion_allowed_cidrs` to your public IP.
4. Run Terraform plan and apply from `terraform/environments/dev`.

## Validation commands

Windows PowerShell:

```powershell
Set-Location e:\eks_project\terraform\environments\dev
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out phase1.tfplan
```

Linux and macOS:

```bash
cd /path/to/eks_project/terraform/environments/dev
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out phase1.tfplan
```

## What comes next

The repository already contains the remaining phases as code and documentation. The next practical step is applying the AWS resources in your account, pushing the repository to Git, and following the execution guide to deploy the cluster add-ons, workloads, Jenkins, and ArgoCD.

