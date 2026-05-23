# Phase 1 Troubleshooting Guide

This file focuses on infrastructure-foundation failures. For application, GitOps, ingress, Jenkins, and certificate failures, use this together with `docs/Execution-Guide.md`, `docs/Kubernetes-Internals.md`, and `docs/Demo-Scenarios.md`.

## Terraform command not found

Problem:

- The shell says `terraform` is not recognized.

Fix:

- Install Terraform.
- Open a new terminal after installation.
- Run `terraform version` again.

## AWS authentication fails

Problem:

- `aws sts get-caller-identity` returns an authentication error.

Fix:

- Run `aws configure` again.
- Verify the access key belongs to an active IAM user.
- Check whether MFA or SSO is required in your organization.

## Availability Zone error

Problem:

- Terraform says a chosen Availability Zone is invalid.

Why it happens:

- Not every account exposes every AZ label in every region.

Fix:

```bash
aws ec2 describe-availability-zones --region us-east-1
```

- Replace the `availability_zones` values in `terraform.tfvars` with valid zones from your account.

## CIDR overlap error

Problem:

- Terraform or AWS reports overlapping CIDR ranges.

Fix:

- Ensure public and private subnet ranges do not overlap.
- Ensure the VPC range is large enough to contain every subnet.
- Avoid reusing CIDRs already connected through peering, VPN, or Transit Gateway.

## Bastion host SSH timeout

Problem:

- SSH to the bastion times out.

Fix:

- Confirm `bastion_allowed_cidrs` contains your public IP.
- Confirm the bastion is in a public subnet.
- Confirm the public subnet route table points to the Internet Gateway.
- Prefer SSM Session Manager if you do not want public SSH at all.

## No outbound internet from private subnets

Problem:

- Instances in private subnets cannot download packages.

Fix:

- Confirm a NAT Gateway exists.
- Confirm the private route table sends `0.0.0.0/0` to the NAT Gateway.
- Confirm the NAT Gateway is in a public subnet.
- Confirm the public subnet route table points to the Internet Gateway.

## ACM certificate does not validate

Problem:

- The certificate stays in pending validation.

Fix:

- Confirm `create_dns_resources = true`.
- Confirm `hosted_zone_name` matches a Route53 zone you own.
- Confirm `certificate_domain_name` is inside that zone.
- Wait a few minutes for DNS propagation.

## NAT Gateway cost surprise

Problem:

- The AWS bill is higher than expected.

Why it happens:

- NAT Gateways have hourly cost and per-GB processing cost.

Fix:

- Use `nat_gateway_mode = "single"` for demos.
- Destroy resources when training ends.
- In later phases, use VPC endpoints to reduce NAT traffic.
