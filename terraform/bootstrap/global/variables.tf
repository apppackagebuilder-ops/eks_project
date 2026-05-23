variable "project_name" {
  description = "Project name used in backend resource naming."
  type        = string
  default     = "acme-eks-platform"
}

variable "environment" {
  description = "Environment name used in backend resource naming."
  type        = string
  default     = "global"
}

variable "aws_region" {
  description = "AWS region for the remote state resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile used during bootstrap."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the backend bucket for demos."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for backend resources."
  type        = map(string)
  default = {
    CostCenter = "training"
    Repo       = "eks-project"
  }
}
