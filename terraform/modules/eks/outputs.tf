output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "API server endpoint for kubectl and automation tools."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN used for IRSA roles."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used for IRSA roles."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_security_group_id" {
  description = "Security group attached to the EKS control plane."
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Security group attached to all EKS worker nodes."
  value       = aws_security_group.nodes.id
}

output "system_node_group_name" {
  description = "System node group name."
  value       = aws_eks_node_group.system.node_group_name
}

output "application_node_group_name" {
  description = "Application node group name."
  value       = aws_eks_node_group.application.node_group_name
}

output "ebs_csi_irsa_role_arn" {
  description = "IRSA role ARN used by the EBS CSI driver add-on."
  value       = aws_iam_role.ebs_csi_irsa.arn
}
