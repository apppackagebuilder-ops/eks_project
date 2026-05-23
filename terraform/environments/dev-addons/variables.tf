variable "aws_region" {
  description = "AWS region where the EKS cluster exists."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name."
  type        = string
  default     = ""
}

variable "infra_state_path" {
  description = "Path to the Terraform state file produced by the dev infrastructure environment."
  type        = string
  default     = "../dev/terraform.tfstate"
}

variable "project_name" {
  description = "Project name used in tags."
  type        = string
  default     = "acme-eks-platform"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags applied to add-on IAM resources."
  type        = map(string)
  default = {
    CostCenter = "training"
    Repo       = "eks-project"
    Owner      = "platform-team"
  }
}
