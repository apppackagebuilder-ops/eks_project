# Phase-by-Phase Guide

This guide follows the exact phase model from the original prompt. Each phase tells you:

- What is being built.
- Why it exists.
- How to execute it.
- How to validate it.
- Common problems.
- How enterprises use it.

## Phase 1: AWS Networking

### What is built

- VPC
- Public and private subnets across two Availability Zones
- Internet Gateway
- NAT Gateway
- Route tables and associations
- Network ACLs
- Security groups
- VPC Flow Logs
- Bastion host
- Optional Route53 and ACM integration
- DHCP options

### Why this exists

EKS needs a secure network boundary before anything can run. In production, the network is the first layer of isolation, routing, and observability.

### Commands

```bash
cd terraform/environments/dev
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out phase1.tfplan
terraform apply phase1.tfplan
```

### Validation

```bash
aws ec2 describe-vpcs --filters Name=tag:Project,Values=acme-eks-platform
aws ec2 describe-subnets --filters Name=tag:Project,Values=acme-eks-platform
aws ec2 describe-nat-gateways --filter Name=tag:Project,Values=acme-eks-platform
aws ec2 describe-flow-logs --filter Name=resource-id,Values=<vpc-id>
```

### Troubleshooting

- If private subnets cannot reach the internet, inspect NAT routes.
- If SSH fails, verify `bastion_allowed_cidrs`.
- If ACM validation stalls, verify the hosted zone and DNS records.

### Enterprise usage

Foundation or cloud platform teams usually create this once and share the subnet outputs with EKS and application teams.

## Phase 2: Terraform Setup

### What is built

- Remote S3 backend
- DynamoDB locking
- Environment folders
- Reusable modules
- tfvars pattern
- outputs and variable interfaces

### Why this exists

Terraform state is critical. Remote state and locking are mandatory when multiple people or pipelines may touch the same infrastructure.

### Commands

```bash
cd terraform/bootstrap/global
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan -out bootstrap.tfplan
terraform apply bootstrap.tfplan
```

Then:

```bash
cd ../../environments/dev
terraform init -backend-config=backend.hcl.example
```

### Validation

```bash
aws s3 ls | grep tfstate
aws dynamodb list-tables | grep terraform-locks
terraform state list
```

### Troubleshooting

- Bucket name conflicts mean S3 naming is globally unique.
- Lock failures usually indicate a stale or active lock in DynamoDB.

### Enterprise usage

This is the minimum safe baseline for team Terraform workflows.

## Phase 3: EKS Cluster

### What is built

- EKS control plane
- Managed node groups
- Cluster security groups
- OIDC provider
- IAM roles and policies
- EKS add-ons for VPC CNI, kube-proxy, CoreDNS, and EBS CSI

### Why this exists

EKS gives you managed Kubernetes while still letting you control nodes, security, add-ons, and workloads.

### Commands

```bash
cd terraform/environments/dev
terraform plan -out phase3.tfplan
terraform apply phase3.tfplan
aws eks update-kubeconfig --name acme-eks-dev --region us-east-1
kubectl get nodes -o wide
```

### Validation

```bash
kubectl get nodes
kubectl get pods -n kube-system
kubectl describe node <node-name>
```

### Troubleshooting

- If nodes do not join, inspect node IAM permissions and private subnet routing.
- If CoreDNS is pending, ensure system nodes exist and can schedule tainted add-ons.

### Enterprise usage

Platform engineering teams standardize cluster creation so application teams do not manually build Kubernetes clusters differently every time.

## Phase 4: Kubernetes Core Add-ons

### What is built

- Metrics Server
- Cluster Autoscaler
- AWS Load Balancer Controller
- EFS CSI Driver
- Karpenter
- cert-manager
- ingress-nginx

### Why this exists

The raw cluster is not enough for production. It needs autoscaling, load balancers, storage drivers, certificates, and ingress.

### Commands

```bash
cd terraform/environments/dev-addons
terraform init
terraform validate
terraform plan -out phase4.tfplan
terraform apply phase4.tfplan
```

### Validation

```bash
kubectl get pods -n kube-system
kubectl get deploy -n cert-manager
kubectl get deploy -n ingress-nginx
kubectl get sa -n kube-system
```

### Troubleshooting

- IRSA issues usually show up as access denied errors in controller logs.
- ALB controller issues often trace back to subnet tags or IAM permissions.

### Enterprise usage

These are standard platform services that every serious EKS environment needs before application onboarding.

## Phase 5: Microservices

### What is built

- Six Python microservices
- REST APIs
- Dockerfiles
- Health endpoints
- Environment variables
- Persistent payment example

### Why this exists

Beginners learn Kubernetes best when they deploy realistic service-to-service applications rather than a single `nginx` container.

### Commands

```bash
docker build -t acme/user-service:dev microservices/user-service
docker build -t acme/product-service:dev microservices/product-service
docker build -t acme/order-service:dev microservices/order-service
docker build -t acme/payment-service:dev microservices/payment-service
docker build -t acme/notification-service:dev microservices/notification-service
docker build -t acme/frontend-ui:dev microservices/frontend-ui
```

### Validation

```bash
python -m py_compile microservices\user-service\app\main.py
python -m py_compile microservices\order-service\app\main.py
```

### Troubleshooting

- If order creation fails, check service URLs and internal DNS.
- If payment writes fail, inspect PVC binding and mount path.

### Enterprise usage

This models typical internal business services with a frontend, API calls, persistence, and downstream notifications.

## Phase 6: Ingress and Certificates

### What is built

- ALB ingress
- NGINX ingress
- cert-manager ClusterIssuer
- frontend certificate resource
- ACM integration path
- HTTPS redirect behavior

### Why this exists

Users need stable HTTPS entry points. Enterprises often mix ALB for public AWS-native ingress and NGINX for internal or custom ingress behavior.

### Commands

```bash
kubectl apply -f kubernetes/certificates/
kubectl apply -f kubernetes/ingress/
kubectl get ingress -A
kubectl get certificate -A
```

### Validation

```bash
kubectl describe ingress platform-alb -n platform-dev
kubectl describe certificate frontend-ui-certificate -n platform-dev
```

### Troubleshooting

- Pending certificate requests usually mean DNS or ingress solver problems.
- Missing ALBs usually mean subnet tagging or IAM issues.

### Enterprise usage

Organizations standardize ingress and TLS so app teams only supply hostnames and paths, not low-level load balancer logic.

## Phase 7: Monitoring Stack

### What is built

- Prometheus
- Grafana
- Alertmanager
- Loki
- Fluent Bit
- CloudWatch output integration
- Dashboards and alert rules

### Why this exists

You cannot operate production systems blindly. Metrics, logs, and alerts are mandatory.

### Commands

```bash
kubectl apply -f kubernetes/observability/
kubectl get pods -n monitoring
kubectl get pods -n logging
```

### Validation

```bash
kubectl get prometheusrule -n monitoring
kubectl get configmap platform-overview-dashboard -n monitoring
kubectl logs daemonset/fluent-bit-demo -n logging
```

### Troubleshooting

- No Grafana dashboards usually means the ConfigMap label or sidecar import settings are wrong.
- No logs in Loki often means Fluent Bit output settings are incorrect.

### Enterprise usage

Site reliability and operations teams use this layer daily to watch latency, error rate, capacity, and service health.

## Phase 8: Jenkins CI/CD

### What is built

- Multibranch pipeline
- Shared library
- JCasC controller config
- Kubernetes agents
- SonarQube, Trivy, and OWASP dependency check stages
- Slack and email notifications

### Why this exists

This automates the path from source code to deployable artifacts and GitOps updates.

### Commands

```bash
helm upgrade --install jenkins jenkins/jenkins -n jenkins -f helm-values/jenkins/values.yaml
kubectl get pods -n jenkins
```

### Validation

```bash
kubectl logs statefulset/jenkins -n jenkins
kubectl get ingress -n jenkins
```

### Troubleshooting

- Agent startup problems usually mean Kubernetes cloud config or image issues.
- Shared library failures usually mean library registration or SCM auth issues.

### Enterprise usage

Many enterprises still use Jenkins where pipelines need strong customization, plugin support, or hybrid platform integration.

## Phase 9: ArgoCD GitOps

### What is built

- ArgoCD install values
- AppProject
- Root application
- Child applications for dev, qa, stage, and prod
- Auto-sync and self-heal

### Why this exists

GitOps reduces configuration drift and makes deployments auditable through Git history.

### Commands

```bash
helm upgrade --install argocd argo/argo-cd -n argocd -f helm-values/argocd/values.yaml
kubectl apply -f argocd/projects/platform-project.yaml
kubectl apply -f argocd/bootstrap/root-application.yaml
kubectl get applications -n argocd
```

### Validation

```bash
kubectl get applications -n argocd
kubectl describe application platform-dev -n argocd
```

### Troubleshooting

- OutOfSync loops usually mean manual changes in the cluster or incorrect paths/value files.
- Sync errors usually mean missing namespaces, CRDs, or invalid manifests.

### Enterprise usage

GitOps is now a common production operating model for Kubernetes platforms because it improves consistency and rollback visibility.

## Phase 10: Security Hardening

### What is built

- IRSA
- RBAC
- Service accounts
- Pod Security Standards
- Network policies
- Security groups
- Image scanning pipeline hooks
- WAF and Shield explanation

### Why this exists

Security must be built into the platform, not bolted on later.

### Commands

```bash
kubectl apply -f kubernetes/security/
kubectl apply -f kubernetes/core/rbac-viewer.yaml
kubectl get networkpolicy -A
kubectl get role,rolebinding -n platform-dev
```

### Validation

```bash
kubectl auth can-i list pods -n platform-dev --as system:serviceaccount:platform-dev:support-viewer
kubectl describe namespace platform-dev
```

### Troubleshooting

- AccessDenied in controller logs often means IRSA mapping issues.
- Unexpected traffic blocks often mean an overly strict network policy.

### Enterprise usage

Security teams expect least privilege, auditability, segmentation, and supply chain scanning as baseline capabilities.

## Phase 11: Production Optimization

### What is built

- HPA definitions
- PDBs
- multi-AZ topology
- Karpenter node pool
- EFS and EBS storage choices
- cost and optimization guidance

### Why this exists

Production platforms need resilience, scaling, and budget control, not just initial deployment success.

### Commands

```bash
kubectl get hpa -A
kubectl get pdb -A
kubectl get nodepool
```

### Validation

```bash
kubectl describe hpa frontend-ui -n platform-dev
kubectl describe pdb frontend-ui -n platform-dev
```

### Troubleshooting

- If HPA shows unknown metrics, confirm Metrics Server is healthy.
- If pods refuse eviction during maintenance, inspect PDB settings.

### Enterprise usage

This is where platforms become sustainable in the long term instead of only technically functional.

## Phase 12: Final Documentation

### What is built

- README
- Architecture guides
- Deployment guides
- Security guide
- Operations guide
- Troubleshooting guide
- Demo scenarios
- Interview preparation
- requirement mapping and walkthroughs

### Why this exists

Documentation is part of the product. A platform that nobody can operate or learn from is not production-grade.

### Commands

Read in this order:

1. `README.md`
2. `docs/Repository-Structure.md`
3. `docs/Platform-Architecture.md`
4. `docs/Phase-by-Phase-Guide.md`
5. `docs/Execution-Guide.md`
6. `docs/Demo-Scenarios.md`

### Validation

- A beginner should be able to follow the steps without guessing.
- Each phase should have commands, validation, and troubleshooting.

### Enterprise usage

Good docs reduce operational risk, shorten onboarding time, and make audits and handovers much easier.
