variable "project_name" {
  description = "Project identifier used in resource names."
  type        = string
  default     = "acme-eks-platform"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region used for this environment."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name. Leave empty to use the default credential chain."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR for the environment."
  type        = string
  default     = "10.42.0.0/16"
}

variable "availability_zones" {
  description = "Two or more Availability Zones for the networking foundation."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs aligned with the Availability Zones list."
  type        = list(string)
  default     = ["10.42.0.0/24", "10.42.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs aligned with the Availability Zones list."
  type        = list(string)
  default     = ["10.42.10.0/24", "10.42.11.0/24"]
}

variable "nat_gateway_mode" {
  description = "Use single for demo cost savings or one_per_az for stronger availability."
  type        = string
  default     = "single"
}

variable "enable_vpc_flow_logs" {
  description = "Enable CloudWatch-backed VPC flow logs."
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "VPC flow log retention."
  type        = number
  default     = 30
}

variable "enable_bastion_host" {
  description = "Create a small bastion host for break-glass access."
  type        = bool
  default     = true
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host."
  type        = string
  default     = "t3.micro"
}

variable "bastion_allowed_cidrs" {
  description = "Source ranges allowed to reach bastion SSH. Restrict this before production use."
  type        = list(string)
  default     = ["203.0.113.10/32"]
}

variable "bastion_key_name" {
  description = "Optional EC2 key pair name. When null, use SSM Session Manager only."
  type        = string
  default     = null
}

variable "create_dns_resources" {
  description = "Lookup an existing public Route53 hosted zone when true."
  type        = bool
  default     = false
}

variable "hosted_zone_name" {
  description = "Existing public hosted zone name."
  type        = string
  default     = null
}

variable "create_acm_certificate" {
  description = "Request an ACM certificate for ingress endpoints when true."
  type        = bool
  default     = false
}

variable "certificate_domain_name" {
  description = "Primary certificate DNS name."
  type        = string
  default     = null
}

variable "certificate_subject_alternative_names" {
  description = "Additional DNS names on the ACM certificate."
  type        = list(string)
  default     = []
}

variable "dhcp_domain_name" {
  description = "Optional DHCP domain name override."
  type        = string
  default     = null
}

variable "dhcp_domain_name_servers" {
  description = "DHCP DNS servers. AmazonProvidedDNS is the safest default."
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "tags" {
  description = "Extra environment tags."
  type        = map(string)
  default = {
    CostCenter = "training"
    Repo       = "eks-project"
  }
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "acme-eks-dev"
}

variable "cluster_version" {
  description = "EKS control plane version."
  type        = string
  default     = "1.33"
}

variable "kubernetes_service_cidr" {
  description = "Service CIDR used by Kubernetes for ClusterIP services."
  type        = string
  default     = "172.20.0.0/16"
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

variable "cluster_public_access_cidrs" {
  description = "CIDRs allowed to reach the EKS public endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "Instance types for the primary application node group."
  type        = list(string)
  default     = ["t3.large"]
}

variable "system_node_instance_types" {
  description = "Instance types for the system node group that hosts cluster services."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "app_node_desired_size" {
  description = "Desired node count for the main application node group."
  type        = number
  default     = 2
}

variable "app_node_min_size" {
  description = "Minimum node count for the main application node group."
  type        = number
  default     = 2
}

variable "app_node_max_size" {
  description = "Maximum node count for the main application node group."
  type        = number
  default     = 5
}

variable "system_node_desired_size" {
  description = "Desired node count for the system add-on node group."
  type        = number
  default     = 2
}

variable "system_node_min_size" {
  description = "Minimum node count for the system add-on node group."
  type        = number
  default     = 2
}

variable "system_node_max_size" {
  description = "Maximum node count for the system add-on node group."
  type        = number
  default     = 4
}

variable "ssh_key_name" {
  description = "Optional EC2 key pair name for node troubleshooting."
  type        = string
  default     = null
}

variable "enable_eks_control_plane_logs" {
  description = "Enable EKS control plane logs in CloudWatch."
  type        = bool
  default     = true
}

variable "eks_log_retention_days" {
  description = "Retention for EKS control plane logs in CloudWatch."
  type        = number
  default     = 30
}

variable "node_disk_size_gb" {
  description = "Disk size for EKS worker nodes."
  type        = number
  default     = 50
}
