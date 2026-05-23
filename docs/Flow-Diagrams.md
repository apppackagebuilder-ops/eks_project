# Flow Diagrams

This document collects the main flows requested in the original prompt.

## 1. Network flow

```mermaid
flowchart LR
    Client[Internet User] --> ALB[Application Load Balancer]
    ALB --> Ingress[Ingress Controller]
    Ingress --> Frontend[frontend-ui Service]
    Frontend --> Order[order-service]
    Order --> User[user-service]
    Order --> Product[product-service]
    Order --> Payment[payment-service]
    Order --> Notify[notification-service]
    Payment --> EBS[(EBS Volume)]
```

ASCII:

```text
Internet User -> ALB -> Ingress -> Frontend -> Order -> User/Product/Payment/Notification
                                                        \
                                                         -> EBS-backed payment data
```

## 2. CI/CD flow

```mermaid
flowchart LR
    Dev[Developer Commit] --> Git[Git Repository]
    Git --> Jenkins[Jenkins Multibranch Pipeline]
    Jenkins --> Sonar[SonarQube Scan]
    Jenkins --> Trivy[Trivy Scan]
    Jenkins --> OWASP[Dependency Check]
    Jenkins --> Build[Docker Build]
    Build --> ECR[Amazon ECR]
    Jenkins --> GitOpsCommit[Update Helm Values in Git]
    GitOpsCommit --> Git
```

ASCII:

```text
Developer -> Git -> Jenkins -> Scan -> Build -> Push Image -> Commit Helm Tag -> Git
```

## 3. GitOps flow

```mermaid
flowchart LR
    Git[Git Desired State] --> ArgoCD[ArgoCD Reconciliation]
    ArgoCD --> Cluster[Kubernetes Cluster]
    Cluster --> Drift[Manual Drift or Failure]
    Drift --> ArgoCD
    ArgoCD --> SelfHeal[Self-Heal and Re-Sync]
```

ASCII:

```text
Git desired state -> ArgoCD -> Cluster
Cluster drift -> ArgoCD detects mismatch -> ArgoCD syncs back to Git state
```

## 4. Kubernetes internals flow

```mermaid
flowchart TB
    Kubectl[kubectl / Jenkins / ArgoCD] --> API[kube-apiserver]
    API --> Etcd[etcd]
    API --> Scheduler[kube-scheduler]
    API --> Controller[kube-controller-manager]
    Scheduler --> Node1[Worker Node]
    Scheduler --> Node2[Worker Node]
    Node1 --> Kubelet1[kubelet]
    Node1 --> Proxy1[kube-proxy]
    Node1 --> CNI1[AWS VPC CNI]
    Node2 --> Kubelet2[kubelet]
    Node2 --> Proxy2[kube-proxy]
    Node2 --> CNI2[AWS VPC CNI]
    API --> DNS[CoreDNS]
```

ASCII:

```text
kubectl/ArgoCD/Jenkins -> kube-apiserver -> etcd
                                 |
                                 +-> scheduler -> worker nodes
                                 +-> controller-manager
Worker nodes run kubelet, kube-proxy, and the CNI plugin
CoreDNS provides service discovery inside the cluster
```

## Why these flows matter

- Network flow explains how users reach the application.
- CI/CD flow explains how code becomes an image and then a deployment candidate.
- GitOps flow explains how Git controls the cluster state.
- Kubernetes internals flow explains how desired state becomes running pods.
