variable "project_name" {
  description = "Short project identifier used in tags and names."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, qa, or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region where the EKS cluster exists."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used by the AWS Load Balancer Controller."
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN exported by the EKS module."
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL exported by the EKS module."
  type        = string
}

variable "cluster_autoscaler_node_groups" {
  description = "Managed node groups discovered and managed by Cluster Autoscaler."
  type        = list(string)
}

variable "tags" {
  description = "Additional tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
