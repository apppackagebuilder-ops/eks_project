# Requirement Matrix

This document cross-checks your original prompt against the generated repository so you can quickly verify coverage.

| Prompt section | Covered by | Notes |
| --- | --- | --- |
| AWS networking | `terraform/modules/networking`, `docs/Architecture.md` | VPC, subnets, NAT, IGW, NACLs, SGs, flow logs, bastion, Route53, ACM, DHCP options are implemented. |
| EKS cluster | `terraform/modules/eks`, `docs/Kubernetes-Internals.md` | Control plane, node groups, IAM, OIDC, IRSA output path, EBS CSI add-on are implemented. |
| Core add-ons | `terraform/modules/eks-addons`, `terraform/environments/dev-addons` | Metrics Server, Cluster Autoscaler, AWS Load Balancer Controller, EFS CSI, cert-manager, ingress-nginx, Karpenter are defined. |
| Microservices application | `microservices/*`, `helm/platform-stack` | User, Product, Order, Payment, Notification, Frontend services are implemented with Dockerfiles and runtime dependencies. |
| Kubernetes deployments | `helm/platform-stack/templates`, `kubernetes/core`, `kubernetes/security`, `kubernetes/storage` | Deployments, StatefulSets, ReplicaSets, DaemonSets, Services, Ingress, RBAC, ServiceAccounts, Secrets, ConfigMaps, PVCs, PVs, NetworkPolicies are covered. |
| Ingress and load balancing | `kubernetes/ingress`, `terraform/modules/eks-addons` | ALB and NGINX ingress controller paths are both included. |
| Certificates | `kubernetes/certificates`, `terraform/modules/networking` | ACM, cert-manager, Let's Encrypt, and renewal flow are covered. |
| Observability | `helm-values/observability`, `kubernetes/observability` | Prometheus, Grafana, Alertmanager, Loki, Fluent Bit, and CloudWatch integration are covered. |
| GitOps | `argocd/bootstrap`, `argocd/projects`, `argocd/apps/*` | App of Apps, auto-sync, self-heal, drift management, and multi-environment patterns are covered. |
| Jenkins CI/CD | `Jenkinsfile`, `jenkins/shared-library`, `jenkins/casc`, `helm-values/jenkins` | Multibranch pipeline, shared library, security scans, notifications, and Helm-based install values are covered. |
| Security | `docs/Security.md`, `kubernetes/security`, `helm/platform-stack/templates/networkpolicy.yaml`, `terraform/modules/eks-addons` | Least privilege, RBAC, IRSA, PSS, network policy, image scanning, WAF and Shield explanations are covered. |
| Storage | `terraform/modules/storage`, `kubernetes/storage`, `helm/platform-stack/templates/pvc.yaml` | EBS dynamic provisioning, EFS file system, StorageClasses, PV/PVC examples are covered. |
| High availability | `terraform/modules/networking`, `terraform/modules/eks`, `helm/platform-stack/templates/pdb.yaml`, `helm/platform-stack/templates/hpa.yaml` | Multi-AZ, autoscaling, self-healing, rolling updates, and disruption budgets are covered. |
| Terraform best practices | `terraform/bootstrap/global`, `terraform/environments/dev/backend.hcl.example`, `docs/Execution-Guide.md` | Remote backend, DynamoDB locking, modules, variables, outputs, tfvars, plan/apply workflow are covered. |
| Repository structure | `README.md`, `docs/Repository-Structure.md`, and repo layout | Enterprise layout is implemented and each folder is explained. |
| Step-by-step execution guide | `docs/Execution-Guide.md`, `docs/Phase-by-Phase-Guide.md` | Commands, validation, expected outputs, troubleshooting, and phase mapping are included. |
| Cost optimization | `docs/Cost-Optimization.md`, `docs/Operations.md` | Demo sizing, NAT cost, spot, node sizing, and budget notes are covered. |
| Interview preparation | `docs/Interview-Preparation.md` | DevOps, Terraform, Kubernetes, EKS, GitOps, Jenkins questions and answers are included. |
| Documentation set | `README.md`, `docs/*.md` | Required docs plus supplemental guides are included. |
| Diagrams | `docs/Architecture.md`, `docs/Platform-Architecture.md`, `docs/Kubernetes-Internals.md`, `docs/Flow-Diagrams.md`, `docs/Demo-Scenarios.md` | Mermaid and ASCII diagrams include network, CI/CD, GitOps, and Kubernetes internals flows. |
| Demo scenarios | `docs/Demo-Scenarios.md` | Scaling, deploy, rollback, node failure, pod failure, GitOps sync, Jenkins deploy, SSL renewal are covered. |
| Phase-by-phase training | `docs/Phase-by-Phase-Guide.md`, `docs/Important-Code-Walkthrough.md` | Each phase includes what was built, why it exists, how to validate it, troubleshooting, and real-world usage. |

## Important implementation note

The repository contains the code and manifests for all requested topics, but any environment-specific values such as your AWS account ID, real DNS zone, public domain, Git remote URL, and secret values still must match your own account before deployment. That is normal for real infrastructure and is explained in the execution guide.
