# End-to-End Execution Guide

This guide is the exact operator sequence for taking the repository from an empty workstation to a running demo platform.

## How to use this guide

This guide is written for a complete beginner.

- Follow the steps in order.
- Do not skip validation commands.
- Do not move to the next phase until the current phase works.
- When a command fails, use the troubleshooting notes immediately instead of pushing ahead.

## Phase map

| Phase | What you are doing | Main folders |
| --- | --- | --- |
| Phase 1 | Build AWS networking | `terraform/modules/networking`, `terraform/environments/dev` |
| Phase 2 | Bootstrap Terraform backend | `terraform/bootstrap/global` |
| Phase 3 | Build the EKS cluster | `terraform/modules/eks`, `terraform/environments/dev` |
| Phase 4 | Install core add-ons | `terraform/modules/eks-addons`, `terraform/environments/dev-addons` |
| Phase 5 | Build and package microservices | `microservices/`, `helm/platform-stack/` |
| Phase 6 | Configure ingress and certificates | `kubernetes/ingress`, `kubernetes/certificates` |
| Phase 7 | Install observability | `helm-values/observability`, `kubernetes/observability` |
| Phase 8 | Install Jenkins CI/CD | `Jenkinsfile`, `jenkins/`, `helm-values/jenkins` |
| Phase 9 | Install ArgoCD GitOps | `argocd/`, `helm-values/argocd` |
| Phase 10 | Apply security hardening | `kubernetes/security`, `kubernetes/core` |
| Phase 11 | Validate optimization and HA | `kubernetes/karpenter`, `helm/platform-stack/templates` |
| Phase 12 | Use docs and demo scenarios | `docs/` |

## Step 1: Prepare your AWS account

1. Create or sign in to an AWS account.
2. Enable MFA on the root user.
3. Create an IAM administrator user for bootstrap only.
4. Create a budget alarm in AWS Budgets for a low threshold such as `$50`.

## Step 2: Install workstation tools

### Windows

```powershell
winget install Amazon.AWSCLI
winget install Hashicorp.Terraform
winget install Kubernetes.kubectl
winget install Helm.Helm
winget install Weaveworks.Eksctl
winget install Docker.DockerDesktop
winget install Git.Git
```

### macOS

```bash
brew install awscli terraform kubectl helm eksctl docker git
```

### Ubuntu or Debian

```bash
sudo apt-get update
sudo apt-get install -y unzip curl gnupg software-properties-common docker.io git
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

## Step 3: Verify tools

```bash
aws --version
terraform version
kubectl version --client
helm version
eksctl version
docker --version
git --version
```

## Step 4: Configure AWS CLI

```bash
aws configure
aws sts get-caller-identity
```

## Step 5: Bootstrap Terraform remote state

Why this step exists:

- Terraform needs a safe place to store state.
- Teams should not share a local `.tfstate` file over email or chat.
- DynamoDB locking prevents two applies from corrupting state at the same time.

```bash
cd terraform/bootstrap/global
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out bootstrap.tfplan
terraform apply bootstrap.tfplan
```

Expected output:

- One S3 bucket for state.
- One DynamoDB table for locking.

Validation:

```bash
aws s3 ls
aws dynamodb list-tables
```

After bootstrap, initialize the `dev` environment with the backend configuration:

```bash
cd ../../environments/dev
terraform init -backend-config=backend.hcl.example
```

## Step 6: Deploy networking, EKS, and storage

This step covers Phase 1 and Phase 3 together because the repository composes networking, EKS, and storage in the `dev` environment.

Update:

- `terraform/environments/dev/terraform.tfvars`
- `bastion_allowed_cidrs`
- `cluster_public_access_cidrs`
- DNS and ACM settings if you own a Route53 zone

Commands:

```bash
cd terraform/environments/dev
terraform fmt -recursive
terraform validate
terraform plan -out dev.tfplan
terraform apply dev.tfplan
```

Expected output:

- VPC and subnets
- NAT Gateway and routes
- EKS cluster endpoint
- system and application node groups
- EFS file system ID

Validation:

```bash
terraform output
aws eks describe-cluster --name acme-eks-dev --region us-east-1
```

Troubleshooting:

- If node groups fail, inspect subnet reachability and IAM attachments.
- If the cluster is created but nodes do not join, verify NAT and private subnet routes.

## Step 7: Configure kubectl for EKS

Why this step exists:

- Terraform created the cluster, but `kubectl` still needs local credentials.
- `aws eks update-kubeconfig` writes the cluster context into your kubeconfig file.

```bash
aws eks update-kubeconfig --name acme-eks-dev --region us-east-1
kubectl get nodes
```

Expected result:

- Two system nodes and two application nodes should appear.

## Step 8: Deploy cluster add-ons

This is Phase 4.

Why this step exists:

- A raw EKS cluster is not enough for production use.
- You need autoscaling, ingress, storage drivers, certificates, and metrics.

```bash
cd ../dev-addons
terraform init
terraform validate
terraform plan -out addons.tfplan
terraform apply addons.tfplan
```

Validate:

```bash
kubectl get pods -n kube-system
kubectl get pods -n cert-manager
kubectl get pods -n ingress-nginx
kubectl get pods -n monitoring
kubectl get pods -n logging
```

Expected output:

- Running pods for Metrics Server, Cluster Autoscaler, AWS Load Balancer Controller, cert-manager, ingress-nginx, and Karpenter.

## Step 9: Build and push images

This is Phase 5.

Why this step exists:

- Kubernetes deploys container images, not raw source folders.
- Jenkins will automate this later, but beginners should first understand the manual path.

Create an ECR repository for each service:

```bash
aws ecr create-repository --repository-name user-service
aws ecr create-repository --repository-name product-service
aws ecr create-repository --repository-name order-service
aws ecr create-repository --repository-name payment-service
aws ecr create-repository --repository-name notification-service
aws ecr create-repository --repository-name frontend-ui
```

Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 111122223333.dkr.ecr.us-east-1.amazonaws.com
```

Build images locally for a first manual deployment:

```bash
docker build -t acme/user-service:dev microservices/user-service
docker build -t acme/product-service:dev microservices/product-service
docker build -t acme/order-service:dev microservices/order-service
docker build -t acme/payment-service:dev microservices/payment-service
docker build -t acme/notification-service:dev microservices/notification-service
docker build -t acme/frontend-ui:dev microservices/frontend-ui
```

Validation:

```bash
docker images | grep acme
```

## Step 10: Deploy the application chart

This continues Phase 5.

Why this step exists:

- Helm packages all six services, their ConfigMaps, Secrets, Services, HPA objects, PVCs, and ingress into one controlled release.

```bash
helm upgrade --install platform-dev helm/platform-stack -n platform-dev --create-namespace -f helm/platform-stack/values.yaml -f helm/platform-stack/values-dev.yaml
kubectl get pods -n platform-dev
kubectl get svc -n platform-dev
kubectl get ingress -n platform-dev
```

Expected output:

- Pods running in `platform-dev`
- Internal ClusterIP services
- An ingress resource for the frontend

Troubleshooting:

- If pods are `CrashLoopBackOff`, inspect `kubectl logs`.
- If the payment service is pending, inspect the PVC.

## Step 11: Install ArgoCD

This is Phase 9.

Why this step exists:

- ArgoCD continuously reconciles the cluster to the desired state stored in Git.
- This is how the repository demonstrates GitOps.

```bash
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd -n argocd -f helm-values/argocd/values.yaml
kubectl apply -f argocd/projects/platform-project.yaml
kubectl apply -f argocd/bootstrap/root-application.yaml
kubectl get applications -n argocd
```

Login:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
argocd login argocd.dev.example.com
```

Validation:

```bash
kubectl get applications -n argocd
kubectl describe application acme-platform-root -n argocd
```

## Step 12: Install Jenkins

This is Phase 8.

Why this step exists:

- Jenkins builds and scans the images.
- It also updates Git so ArgoCD can deploy changes through GitOps.

```bash
kubectl create namespace jenkins
helm repo add jenkins https://charts.jenkins.io
helm upgrade --install jenkins jenkins/jenkins -n jenkins -f helm-values/jenkins/values.yaml
kubectl get pods -n jenkins
```

Validation:

```bash
kubectl get ingress -n jenkins
kubectl logs statefulset/jenkins -n jenkins
```

## Step 13: Validate observability

This is Phase 7.

Why this step exists:

- Production platforms need metrics, logs, dashboards, and alerts.
- This phase proves your observability stack is actually running.

```bash
kubectl get pods -n monitoring
kubectl get pods -n logging
kubectl get prometheusrule -n monitoring
kubectl get configmap -n monitoring | grep dashboard
```

Expected output:

- Prometheus, Grafana, Alertmanager, Loki, and Fluent Bit resources visible in the cluster.

## Step 14: Validate ingress and certificates

This is Phase 6.

Why this step exists:

- HTTPS is a production requirement, not an optional extra.
- Ingress and certificate checks verify the public access path.

```bash
kubectl get ingress -A
kubectl get certificate -A
kubectl describe certificate frontend-ui-certificate -n platform-dev
```

Troubleshooting:

- If no ALB is created, check the AWS Load Balancer Controller logs.
- If the certificate is not ready, inspect cert-manager logs and DNS.

## Step 14A: Validate security hardening

This is Phase 10.

```bash
kubectl get networkpolicy -A
kubectl get role,rolebinding -n platform-dev
kubectl auth can-i list pods -n platform-dev --as system:serviceaccount:platform-dev:support-viewer
```

Expected output:

- Network policies present.
- RBAC objects present.
- Read-only actions allowed for the support viewer account.

## Step 14B: Validate high availability and optimization

This is Phase 11.

```bash
kubectl get hpa -A
kubectl get pdb -A
kubectl get nodepool
```

Expected output:

- HPA objects for stateless services.
- PodDisruptionBudgets for protected workloads.
- A Karpenter node pool for just-in-time capacity.

## Step 15: Destroy the demo when finished

```bash
helm uninstall platform-dev -n platform-dev
cd terraform/environments/dev-addons && terraform destroy -auto-approve
cd ../dev && terraform destroy -auto-approve
cd ../../bootstrap/global && terraform destroy -auto-approve
```

## Troubleshooting shortcuts

```bash
kubectl get events -A --sort-by=.lastTimestamp
kubectl logs deploy/aws-load-balancer-controller -n kube-system
kubectl logs deploy/cluster-autoscaler -n kube-system
kubectl logs deploy/argocd-server -n argocd
kubectl logs statefulset/jenkins -n jenkins
terraform state list
```

## Next documents to read

After you finish the build, continue with:

1. `docs/Phase-by-Phase-Guide.md`
2. `docs/Demo-Scenarios.md`
3. `docs/Important-Code-Walkthrough.md`
4. `docs/Interview-Preparation.md`
