# This file intentionally contains a working demo configuration.
# Update the allowed bastion CIDR before applying from your environment.

project_name                          = "acme-eks-platform"
environment                           = "dev"
aws_region                            = "us-east-1"
aws_profile                           = ""
vpc_cidr                              = "10.42.0.0/16"
availability_zones                    = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs                   = ["10.42.0.0/24", "10.42.1.0/24"]
private_subnet_cidrs                  = ["10.42.10.0/24", "10.42.11.0/24"]
nat_gateway_mode                      = "single"
enable_vpc_flow_logs                  = true
flow_log_retention_days               = 30
enable_bastion_host                   = true
bastion_instance_type                 = "t3.micro"
bastion_allowed_cidrs                 = ["203.0.113.10/32"]
bastion_key_name                      = null
create_dns_resources                  = false
hosted_zone_name                      = null
create_acm_certificate                = false
certificate_domain_name               = null
certificate_subject_alternative_names = []
dhcp_domain_name                      = null
dhcp_domain_name_servers              = ["AmazonProvidedDNS"]

tags = {
  CostCenter = "training"
  Repo       = "eks-project"
  Owner      = "platform-team"
}

cluster_name                    = "acme-eks-dev"
cluster_version                 = "1.33"
kubernetes_service_cidr         = "172.20.0.0/16"
cluster_endpoint_public_access  = true
cluster_endpoint_private_access = true
cluster_public_access_cidrs     = ["203.0.113.10/32"]
node_instance_types             = ["t3.large"]
system_node_instance_types      = ["t3.medium"]
app_node_desired_size           = 2
app_node_min_size               = 2
app_node_max_size               = 5
system_node_desired_size        = 2
system_node_min_size            = 2
system_node_max_size            = 4
ssh_key_name                    = null
enable_eks_control_plane_logs   = true
eks_log_retention_days          = 30
node_disk_size_gb               = 50
