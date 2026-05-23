output "aws_load_balancer_controller_role_arn" {
  description = "IRSA role ARN for the AWS Load Balancer Controller."
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "cluster_autoscaler_role_arn" {
  description = "IRSA role ARN for the Cluster Autoscaler."
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "efs_csi_role_arn" {
  description = "IRSA role ARN for the EFS CSI driver."
  value       = aws_iam_role.efs_csi.arn
}

output "karpenter_controller_role_arn" {
  description = "IRSA role ARN for the Karpenter controller."
  value       = aws_iam_role.karpenter_controller.arn
}
