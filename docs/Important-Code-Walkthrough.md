# Important Code Walkthrough

This guide explains the most important code blocks in the repository and why each one matters.

## 1. Networking module

File: `terraform/modules/networking/main.tf`

### Why it matters

This module creates the base AWS network that every later phase depends on.

### Key logic explained

- `locals` block
  Why it exists: centralizes repeated values such as common tags and subnet maps.
  How it works: turns lists of AZs and CIDRs into predictable maps used by `for_each`.

- `aws_vpc.this`
  Why it exists: creates the network boundary.
  Important setting: `enable_dns_hostnames = true` so private DNS names work properly for instances and EKS.

- `aws_subnet.public` and `aws_subnet.private`
  Why they exist: separate internet-facing infrastructure from protected compute workloads.
  Important tags: subnet tags support future load balancer placement in EKS.

- `aws_nat_gateway.this`
  Why it exists: gives private workloads outbound internet access without public exposure.

- `aws_flow_log.this`
  Why it exists: provides network-level observability for security and troubleshooting.

## 2. EKS module

File: `terraform/modules/eks/main.tf`

### Why it matters

This module builds the managed Kubernetes cluster and the foundational AWS permissions around it.

### Key logic explained

- `aws_eks_cluster.this`
  Why it exists: creates the managed control plane.
  Important settings:
  `access_config` enables modern access handling.
  `encryption_config` protects Kubernetes secrets at rest with KMS.
  `vpc_config` decides whether the API endpoint is public, private, or both.

- `aws_iam_openid_connect_provider.this`
  Why it exists: enables IRSA.
  What problem it solves: lets pods use dedicated IAM roles instead of broad node permissions.

- `aws_eks_node_group.system` and `aws_eks_node_group.application`
  Why they exist: separate system workloads from business workloads.
  Enterprise reason: this improves stability and makes scheduling behavior more predictable.

- `aws_eks_addon` resources
  Why they exist: install supported managed add-ons such as VPC CNI, CoreDNS, kube-proxy, and EBS CSI.

## 3. EKS add-ons module

File: `terraform/modules/eks-addons/main.tf`

### Why it matters

This module installs the real platform services that make the cluster production-usable.

### Key logic explained

- `aws_iam_role` plus `kubernetes_service_account`
  Why this pattern exists: it is the IRSA pattern.
  How it works internally: Kubernetes service accounts receive annotations that point to IAM roles trusted by the cluster OIDC provider.

- `helm_release.metrics_server`
  Why it exists: HPA and many metrics-based views depend on it.

- `helm_release.cluster_autoscaler`
  Why it exists: automatically scales node groups when scheduling pressure changes.

- `helm_release.aws_load_balancer_controller`
  Why it exists: turns Kubernetes Ingress and LoadBalancer resources into AWS load balancers.

- `helm_release.karpenter`
  Why it exists: enables just-in-time capacity provisioning.

## 4. Helm application chart

Files:

- `helm/platform-stack/values.yaml`
- `helm/platform-stack/templates/*.yaml`

### Why it matters

This is the reusable application packaging layer.

### Key logic explained

- `applications:` in `values.yaml`
  Why it exists: drives the whole chart from data instead of hand-writing each manifest repeatedly.
  Enterprise reason: one chart can manage multiple services across environments.

- `templates/deployment.yaml`
  Why it exists: deploys stateless workloads.
  Important settings: rolling updates, resource requests and limits, health probes, security context.

- `templates/statefulset.yaml`
  Why it exists: deploys the payment service with persistent storage.

- `templates/hpa.yaml`
  Why it exists: automatically scales stateless workloads based on CPU usage.

- `templates/networkpolicy.yaml`
  Why it exists: enforces least-privilege traffic flow between workloads.

- `templates/ingress.yaml`
  Why it exists: exposes the frontend using ingress rules and controller-specific annotations.

## 5. Jenkins pipeline

File: `Jenkinsfile`

### Why it matters

This defines the CI/CD workflow from source code to deployable change.

### Key logic explained

- `@Library('acme-shared-library')`
  Why it exists: imports reusable pipeline functions.

- `stage('Static Analysis')`
  Why it exists: finds security or quality issues before images are built.

- `stage('Build and Scan Images')`
  Why it exists: builds container artifacts and scans them for vulnerabilities.

- `stage('Terraform Plan')`
  Why it exists: infrastructure changes should be previewed before apply.

- `stage('Deploy to Dev via GitOps')`
  Why it exists: updates Git instead of pushing directly to the cluster.
  Enterprise reason: this preserves Git as the source of truth.

## 6. ArgoCD root application

File: `argocd/bootstrap/root-application.yaml`

### Why it matters

This is the App of Apps entry point.

### Key logic explained

- `source.path: argocd/apps/dev`
  Why it exists: points ArgoCD to a directory full of child applications.

- `automated.prune: true`
  Why it exists: removes resources no longer declared in Git.

- `automated.selfHeal: true`
  Why it exists: corrects manual drift in the cluster automatically.

## 7. Observability rules and dashboard

Files:

- `kubernetes/observability/prometheus-rules.yaml`
- `kubernetes/observability/grafana-dashboard-configmap.yaml`

### Why they matter

They define what the platform watches and how operators see it.

### Key logic explained

- Alert rules
  Why they exist: detect error spikes and high latency before users complain.

- Dashboard ConfigMap
  Why it exists: keeps dashboards versioned in Git so they can be reviewed, restored, and promoted like code.

## What a beginner should take away

The repository is not a random pile of YAML and Terraform. Each layer has a clear role:

1. Terraform builds AWS foundations.
2. Kubernetes and Helm define how workloads run.
3. Jenkins automates build and release.
4. ArgoCD automates desired-state reconciliation.
5. Observability and security make the platform safe and operable.
