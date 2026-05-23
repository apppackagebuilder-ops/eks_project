# Phase 1 Operations Guide

This guide explains how to operate the networking layer after deployment.

For the full platform operating model, combine this document with `docs/Execution-Guide.md`, `docs/Demo-Scenarios.md`, and the observability manifests under `kubernetes/observability`.

## Daily validation checks

Confirm the VPC exists:

```bash
aws ec2 describe-vpcs --filters Name=tag:Project,Values=acme-eks-platform --query "Vpcs[].{VpcId:VpcId,Cidr:CidrBlock,State:State}"
```

Confirm subnets are distributed across AZs:

```bash
aws ec2 describe-subnets --filters Name=tag:Project,Values=acme-eks-platform --query "Subnets[].{SubnetId:SubnetId,Az:AvailabilityZone,Cidr:CidrBlock,PublicIpOnLaunch:MapPublicIpOnLaunch}"
```

Confirm flow logs exist:

```bash
aws logs describe-log-groups --log-group-name-prefix "/aws/vpc/acme-eks-platform-dev"
```

## What to monitor in production

- NAT Gateway availability and data processing cost.
- VPC Flow Log delivery failures.
- Bastion host unexpected runtime or access attempts.
- IP address consumption within subnets.

## Cost optimization notes

- Use a single NAT Gateway for demos and small labs.
- Disable the bastion if Session Manager is enough.
- Destroy the environment when idle.
- Later phases should add VPC endpoints for services like ECR, S3, and CloudWatch to reduce NAT cost.

## Production best practices introduced in this phase

- Multi-AZ networking from day one.
- Private application subnets.
- Logging enabled by default.
- Tags added for ownership and cost tracking.
- Reusable modules instead of copy-paste infrastructure.

## Real-world enterprise usage

In many organizations, this network stack is created once by a platform or cloud foundation team. Application and Kubernetes teams then consume the outputs such as VPC ID and subnet IDs instead of building their own networks every time.
