# Interview Preparation

## DevOps questions

### What is the difference between CI and CD?

Continuous Integration means developers frequently merge changes and automatically run validation such as tests and scans. Continuous Delivery means the code is always in a deployable state. Continuous Deployment goes one step further and automatically deploys approved changes to production.

### Why use GitOps?

GitOps makes Git the source of truth for cluster state. It improves auditability, rollback safety, peer review, and drift detection. In this project, ArgoCD compares Git to the cluster and self-heals drift.

## Terraform questions

### What is Terraform state and why is it important?

State is Terraform's memory of what it created. Without it, Terraform cannot accurately plan changes. In production, state belongs in remote storage with locking, which is why this repository uses S3 and DynamoDB.

### What is drift in Terraform?

Drift happens when real infrastructure changes outside Terraform. Terraform plans will then show differences between the desired state in code and the real state in AWS.

## Kubernetes questions

### What is the difference between a Deployment and a StatefulSet?

A Deployment manages stateless pods with interchangeable identities. A StatefulSet manages stable identities and ordered rollouts for stateful workloads such as databases or queue brokers.

### Why do we need a Service if pods already have IP addresses?

Pod IPs change whenever pods restart. A Service gives clients a stable virtual IP and DNS name that stays constant while the backend pods change.

## EKS questions

### What does EKS manage for you?

EKS manages the control plane components, availability of the API server, and integration with AWS IAM and networking. You still manage worker nodes, add-ons, applications, and many operational choices.

### What is IRSA and why is it important?

IRSA stands for IAM Roles for Service Accounts. It lets a pod assume its own IAM role instead of inheriting broad node permissions. This is a best practice for least privilege in EKS.

## GitOps questions

### What is drift detection?

Drift detection is the process of noticing that the cluster no longer matches the desired declarative configuration in Git. ArgoCD highlights this and can automatically reconcile it.

### What is the App of Apps pattern?

It is a root ArgoCD Application that points to a directory containing child Application manifests. This lets teams bootstrap many applications and environments from one entry point.

## Jenkins questions

### Why use shared libraries in Jenkins?

Shared libraries prevent pipeline logic from being copy-pasted across many repositories. Reusable steps such as image builds, Trivy scans, and Terraform workflows stay centralized.

### How do you secure Jenkins on Kubernetes?

Use ingress TLS, least-privilege service accounts, external secrets or managed secrets, JCasC, ephemeral agents, and image scanning. Also avoid running builds directly on the controller.
