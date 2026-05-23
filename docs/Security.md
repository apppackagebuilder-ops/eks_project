# Phase 1 Security Guide

Security starts in the network layer. A secure EKS platform depends on secure foundations.

This document explains the foundational layer. The cluster, CI/CD, supply chain, and GitOps security model are extended across the repository in `terraform/modules/eks`, `terraform/modules/eks-addons`, `Jenkinsfile`, and `helm/platform-stack`.

## Why private subnets matter

The strongest security control in this phase is placing future worker nodes in private subnets. That removes direct internet exposure from the compute layer.

## IAM guidance for beginners

Use IAM users or roles with the least privilege needed.

For training:

- One administrative IAM user can bootstrap the account.
- Later phases should replace broad permissions with narrower Terraform and platform roles.

## Bastion security recommendations

- Restrict `bastion_allowed_cidrs` to your exact public IP.
- Prefer AWS Systems Manager Session Manager over open SSH.
- Keep IMDSv2 required, which this Terraform module already enforces.
- Destroy the bastion when the demo is over.

## Security groups vs NACLs

Security Groups are stateful and should be your main access control tool.
Network ACLs are stateless and provide a subnet-level guardrail.

## Why VPC Flow Logs improve security

Flow logs help answer questions like:

- Which source attempted a connection?
- Was the traffic accepted or rejected?
- Which interface saw the traffic?

That makes them useful for incident response and compliance review.

## Zero trust in plain language

Zero trust means you do not assume a network location is safe by default. Every request and every identity should be validated. In AWS and Kubernetes, that usually means:

- Strong IAM boundaries.
- Minimal network access.
- Short-lived credentials.
- Logging and auditability.

## WAF and AWS Shield explanation

AWS WAF:

- Filters HTTP traffic.
- Helps block SQL injection, bot traffic, and common web attacks.
- Typically attaches to CloudFront or Application Load Balancers.

AWS Shield:

- Protects against DDoS attacks.
- Shield Standard is included automatically for many AWS services.
- Shield Advanced adds deeper visibility and response support.

These are not deployed in Phase 1 because there is no public application yet, but they become important once ingress is exposed in later phases.
