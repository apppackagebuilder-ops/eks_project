module "networking" {
  source = "../../modules/networking"

  project_name                          = var.project_name
  environment                           = var.environment
  aws_region                            = var.aws_region
  vpc_cidr                              = var.vpc_cidr
  availability_zones                    = var.availability_zones
  public_subnet_cidrs                   = var.public_subnet_cidrs
  private_subnet_cidrs                  = var.private_subnet_cidrs
  nat_gateway_mode                      = var.nat_gateway_mode
  enable_vpc_flow_logs                  = var.enable_vpc_flow_logs
  flow_log_retention_days               = var.flow_log_retention_days
  enable_bastion_host                   = var.enable_bastion_host
  bastion_instance_type                 = var.bastion_instance_type
  bastion_allowed_cidrs                 = var.bastion_allowed_cidrs
  bastion_key_name                      = var.bastion_key_name
  create_dns_resources                  = var.create_dns_resources
  hosted_zone_name                      = var.hosted_zone_name
  create_acm_certificate                = var.create_acm_certificate
  certificate_domain_name               = var.certificate_domain_name
  certificate_subject_alternative_names = var.certificate_subject_alternative_names
  dhcp_domain_name                      = var.dhcp_domain_name
  dhcp_domain_name_servers              = var.dhcp_domain_name_servers
  tags                                  = var.tags
}

module "eks" {
  source = "../../modules/eks"

  project_name                    = var.project_name
  environment                     = var.environment
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  kubernetes_service_cidr         = var.kubernetes_service_cidr
  vpc_id                          = module.networking.vpc_id
  private_subnet_ids              = values(module.networking.private_subnet_ids)
  public_subnet_ids               = values(module.networking.public_subnet_ids)
  cluster_public_access_cidrs     = var.cluster_public_access_cidrs
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  node_instance_types             = var.node_instance_types
  system_node_instance_types      = var.system_node_instance_types
  app_node_desired_size           = var.app_node_desired_size
  app_node_min_size               = var.app_node_min_size
  app_node_max_size               = var.app_node_max_size
  system_node_desired_size        = var.system_node_desired_size
  system_node_min_size            = var.system_node_min_size
  system_node_max_size            = var.system_node_max_size
  ssh_key_name                    = var.ssh_key_name
  enable_eks_control_plane_logs   = var.enable_eks_control_plane_logs
  eks_log_retention_days          = var.eks_log_retention_days
  node_disk_size_gb               = var.node_disk_size_gb
  tags                            = var.tags
}

module "storage" {
  source = "../../modules/storage"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = values(module.networking.private_subnet_ids)
  allowed_security_groups = [module.eks.node_security_group_id]
  tags                    = var.tags
}
