output "vpc_id" {
  description = "VPC ID created for the dev environment."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs used for ingress-facing resources and the bastion host."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs where EKS worker nodes will run in later phases."
  value       = module.networking.private_subnet_ids
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host when enabled."
  value       = module.networking.bastion_public_ip
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN when certificate creation is enabled."
  value       = module.networking.acm_certificate_arn
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster certificate authority data."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN used by IRSA roles in later phases."
  value       = module.eks.cluster_oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used by IRSA roles in later phases."
  value       = module.eks.cluster_oidc_issuer_url
}

output "system_node_group_name" {
  description = "Name of the system node group."
  value       = module.eks.system_node_group_name
}

output "application_node_group_name" {
  description = "Name of the application node group."
  value       = module.eks.application_node_group_name
}

output "efs_file_system_id" {
  description = "EFS file system ID used for shared persistent storage."
  value       = module.storage.efs_file_system_id
}

output "efs_security_group_id" {
  description = "Security group attached to the EFS mount targets."
  value       = module.storage.efs_security_group_id
}

