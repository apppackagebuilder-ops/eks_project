output "aws_load_balancer_controller_role_arn" {
  description = "IRSA role for the AWS Load Balancer Controller."
  value       = module.eks_addons.aws_load_balancer_controller_role_arn
}

output "cluster_autoscaler_role_arn" {
  description = "IRSA role for the Cluster Autoscaler."
  value       = module.eks_addons.cluster_autoscaler_role_arn
}

output "efs_csi_role_arn" {
  description = "IRSA role for the EFS CSI driver."
  value       = module.eks_addons.efs_csi_role_arn
}

output "karpenter_controller_role_arn" {
  description = "IRSA role for the Karpenter controller."
  value       = module.eks_addons.karpenter_controller_role_arn
}
