locals {
  name = "${var.project_name}-${var.environment}"
  common_tags = merge(var.additional_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "./modules/networking"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = local.name
  tags                 = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  name                        = local.name
  kubernetes_version          = var.kubernetes_version
  private_subnet_ids          = module.networking.private_subnet_ids
  cluster_subnet_ids          = concat(module.networking.public_subnet_ids, module.networking.private_subnet_ids)
  vpc_id                      = module.networking.vpc_id
  administrator_principal_arn = var.administrator_principal_arn
  public_endpoint_access      = var.public_endpoint_access
  public_access_cidrs         = var.public_access_cidrs
  log_retention_days          = var.log_retention_days
  node_instance_types         = var.node_instance_types
  node_disk_size              = var.node_disk_size
  node_desired_size           = var.node_desired_size
  node_min_size               = var.node_min_size
  node_max_size               = var.node_max_size
  tags                        = local.common_tags
}

