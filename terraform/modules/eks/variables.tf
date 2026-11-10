variable "name" { type = string }
variable "kubernetes_version" { type = string }
variable "vpc_id" { type = string }
variable "cluster_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "administrator_principal_arn" { type = string }
variable "public_endpoint_access" { type = bool }
variable "public_access_cidrs" { type = list(string) }
variable "log_retention_days" { type = number }
variable "node_instance_types" { type = list(string) }
variable "node_disk_size" { type = number }
variable "node_desired_size" { type = number }
variable "node_min_size" { type = number }
variable "node_max_size" { type = number }
variable "tags" { type = map(string) }

