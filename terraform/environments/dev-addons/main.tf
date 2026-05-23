module "eks_addons" {
  source = "../../modules/eks-addons"

  project_name              = var.project_name
  environment               = var.environment
  aws_region                = var.aws_region
  cluster_name              = data.terraform_remote_state.infra.outputs.cluster_name
  vpc_id                    = data.terraform_remote_state.infra.outputs.vpc_id
  cluster_oidc_provider_arn = data.terraform_remote_state.infra.outputs.cluster_oidc_provider_arn
  cluster_oidc_issuer_url   = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
  cluster_autoscaler_node_groups = [
    data.terraform_remote_state.infra.outputs.system_node_group_name,
    data.terraform_remote_state.infra.outputs.application_node_group_name,
  ]
  tags = var.tags
}
