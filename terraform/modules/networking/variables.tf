variable "project_name" {
  description = "Short project identifier used in tags and names."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, qa, or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region where networking resources are created."
  type        = string
}

variable "vpc_cidr" {
  description = "Primary CIDR range for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used for the multi-AZ design."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Use at least two Availability Zones for a resilient design."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for public subnets, one per Availability Zone."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Public subnet CIDRs must match the number of Availability Zones."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for private subnets, one per Availability Zone."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "Private subnet CIDRs must match the number of Availability Zones."
  }
}

variable "nat_gateway_mode" {
  description = "Choose single for lower cost or one_per_az for higher availability."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either single or one_per_az."
  }
}

variable "enable_vpc_flow_logs" {
  description = "When true, send VPC flow logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Retention period for VPC flow logs in CloudWatch Logs."
  type        = number
  default     = 30
}

variable "enable_bastion_host" {
  description = "When true, create a small bastion host in a public subnet for break-glass access."
  type        = bool
  default     = true
}

variable "bastion_instance_type" {
  description = "EC2 instance type used for the bastion host."
  type        = string
  default     = "t3.micro"
}

variable "bastion_allowed_cidrs" {
  description = "IPv4 CIDR blocks allowed to SSH to the bastion host."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_key_name" {
  description = "Optional EC2 key pair name for bastion SSH access. Leave null to rely on SSM Session Manager only."
  type        = string
  default     = null
}

variable "create_dns_resources" {
  description = "When true, use an existing Route53 public hosted zone for DNS records."
  type        = bool
  default     = false
}

variable "hosted_zone_name" {
  description = "Existing Route53 public hosted zone name, for example example.com."
  type        = string
  default     = null
}

variable "create_acm_certificate" {
  description = "When true, request an ACM certificate and validate it using Route53 DNS records."
  type        = bool
  default     = false

  validation {
    condition     = var.create_acm_certificate ? var.create_dns_resources : true
    error_message = "create_acm_certificate requires create_dns_resources to be true."
  }
}

variable "certificate_domain_name" {
  description = "Primary FQDN used for the ACM certificate."
  type        = string
  default     = null
}

variable "certificate_subject_alternative_names" {
  description = "Additional DNS names added to the ACM certificate."
  type        = list(string)
  default     = []
}

variable "dhcp_domain_name" {
  description = "Optional custom DHCP domain name for the VPC."
  type        = string
  default     = null
}

variable "dhcp_domain_name_servers" {
  description = "DHCP DNS servers used by EC2 instances. AmazonProvidedDNS keeps Route53 resolver integration."
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
