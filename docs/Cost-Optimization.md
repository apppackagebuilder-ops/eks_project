# Cost Optimization Notes

This repository is production-shaped, but you can still run it in a demo-friendly way.

## Cheapest demo setup

- Use one NAT Gateway instead of one per AZ.
- Keep the environment in `dev` only.
- Use `t3.medium` for system nodes and `t3.large` only where needed.
- Shut down or destroy the environment after training.
- Keep Prometheus retention short in demo environments.

## Free tier limitations

Amazon EKS is not free tier eligible.

Biggest cost sources:

- EKS control plane hourly charge.
- NAT Gateway hourly plus data processing.
- EC2 nodes.
- Load balancers.
- EBS and EFS storage.
- CloudWatch logs and metrics retention.

## Spot instances

Spot is a strong fit for:

- Non-critical dev workloads.
- Batch jobs.
- Scale-out background workers.

Avoid spot-only for:

- Critical system add-ons.
- Single replica stateful services.
- Demos where interruptions would hurt the presentation.

## Estimated monthly cost for a small demo

- EKS control plane: around `$70-$75`
- Two `t3.medium` plus two `t3.large` nodes: around `$120-$180` depending on runtime
- Single NAT Gateway: around `$30-$40` plus traffic
- ALB and NGINX ingress load balancer costs: around `$20-$40`
- EBS, EFS, and logs: around `$20-$50`

Approximate total:

- Small full-time demo: `$260-$385` per month
- Short-lived training lab destroyed daily: much lower

## Budget-friendly alternatives

1. Run only the infrastructure and one or two services at a time.
2. Disable Jenkins and use local builds if you only need GitOps demos.
3. Replace EFS demos with EBS-only demos if shared RWX storage is not needed.
4. Keep ArgoCD and observability installed only when demonstrating those topics.
