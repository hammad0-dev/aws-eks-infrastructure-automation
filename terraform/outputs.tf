output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}
output "aws_region" {
  description = "AWS Region containing the cluster."
  value       = var.aws_region
}
output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint."
  value       = module.eks.cluster_endpoint
  sensitive   = true
}
output "vpc_id" {
  description = "Project VPC ID."
  value       = module.networking.vpc_id
}
output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.networking.public_subnet_ids
}
output "private_subnet_ids" {
  description = "Private subnet IDs used by worker nodes."
  value       = module.networking.private_subnet_ids
}
output "node_group_name" {
  description = "Managed node group name."
  value       = module.eks.node_group_name
}
output "node_role_arn" {
  description = "IAM role used by managed nodes."
  value       = module.eks.node_role_arn
}
