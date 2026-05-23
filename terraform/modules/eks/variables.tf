variable "project_name" {
  description = "Short project identifier used in names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, qa, or prod."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
}

variable "kubernetes_service_cidr" {
  description = "CIDR used for Kubernetes ClusterIP services."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the EKS control plane ENIs and managed node groups."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs that later host ingress-facing load balancers."
  type        = list(string)
}

variable "cluster_public_access_cidrs" {
  description = "CIDR ranges allowed to reach the public EKS API endpoint."
  type        = list(string)
}

variable "cluster_endpoint_public_access" {
  description = "Enable the EKS public API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable the EKS private API endpoint."
  type        = bool
  default     = true
}

variable "node_instance_types" {
  description = "Instance types for the main application node group."
  type        = list(string)
}

variable "system_node_instance_types" {
  description = "Instance types for the system node group."
  type        = list(string)
}

variable "app_node_desired_size" {
  description = "Desired node count for the application node group."
  type        = number
}

variable "app_node_min_size" {
  description = "Minimum node count for the application node group."
  type        = number
}

variable "app_node_max_size" {
  description = "Maximum node count for the application node group."
  type        = number
}

variable "system_node_desired_size" {
  description = "Desired node count for the system node group."
  type        = number
}

variable "system_node_min_size" {
  description = "Minimum node count for the system node group."
  type        = number
}

variable "system_node_max_size" {
  description = "Maximum node count for the system node group."
  type        = number
}

variable "ssh_key_name" {
  description = "Optional EC2 key pair name for node troubleshooting."
  type        = string
  default     = null
}

variable "enable_eks_control_plane_logs" {
  description = "When true, send EKS control plane logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "eks_log_retention_days" {
  description = "Retention period for EKS control plane logs."
  type        = number
  default     = 30
}

variable "node_disk_size_gb" {
  description = "Root volume size for worker nodes."
  type        = number
  default     = 50
}

variable "tags" {
  description = "Additional tags applied to EKS resources."
  type        = map(string)
  default     = {}
}
