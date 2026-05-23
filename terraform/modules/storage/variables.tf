variable "project_name" {
  description = "Short project identifier used in tags and resource names."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, qa, or prod."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EFS mount targets are created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EFS mount targets are created."
  type        = list(string)
}

variable "allowed_security_groups" {
  description = "Security group IDs allowed to mount the EFS file system."
  type        = list(string)
}

variable "tags" {
  description = "Additional tags applied to storage resources."
  type        = map(string)
  default     = {}
}
