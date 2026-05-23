# Demo Scenarios

This guide gives you structured demonstrations that show how a real platform behaves.

## Scenario 1: Scale the application

Command:

```bash
kubectl scale deployment frontend-ui -n platform-dev --replicas=4
kubectl get pods -n platform-dev -w
```

Expected result:

- New pods appear.
- The Service continues routing traffic without changing its name.

## Scenario 2: Deploy a new version

Command:

```bash
python scripts/update_helm_values.py dev 2026.05.23
git add helm/platform-stack/values-dev.yaml
git commit -m "Deploy demo release 2026.05.23"
git push
```

Expected result:

- ArgoCD detects the commit.
- It syncs the new image tag.
- A rolling update replaces the old pods.

## Scenario 3: Roll back

Command:

```bash
kubectl rollout undo deployment/frontend-ui -n platform-dev
kubectl rollout status deployment/frontend-ui -n platform-dev
```

Expected result:

- Kubernetes rolls back to the previous ReplicaSet.

## Scenario 4: Pod failure

Command:

```bash
kubectl delete pod -l app.kubernetes.io/name=frontend-ui -n platform-dev
```

Expected result:

- The Deployment recreates the pod automatically.
- Service availability continues.

## Scenario 5: Node failure

Command:

```bash
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
kubectl get pods -A -o wide
```

Expected result:

- Pods reschedule to other nodes.
- PDBs limit voluntary disruption.
- Cluster Autoscaler or Karpenter can add capacity if needed.

## Scenario 6: GitOps self-heal

Command:

```bash
kubectl scale deployment order-service -n platform-dev --replicas=1
kubectl get applications -n argocd
```

Expected result:

- ArgoCD marks the app OutOfSync.
- It automatically restores the Git-defined replica count.

## Scenario 7: Jenkins-driven deployment

Trigger the multibranch pipeline from Jenkins.

Expected result:

- Jenkins builds images.
- Trivy and dependency checks run.
- Helm values are updated.
- ArgoCD deploys the change.

## Scenario 8: SSL renewal

Command:

```bash
kubectl describe certificate frontend-ui-certificate -n platform-dev
kubectl get certificaterequest -A
```

Expected result:

- cert-manager renews the certificate before expiry.
- The secret is updated automatically.
