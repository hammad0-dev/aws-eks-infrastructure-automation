variable "aws_region" {
  description = "AWS Region in which to create the project resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional shared AWS CLI profile. Set to null to use the normal AWS credential chain."
  type        = string
  default     = null
  nullable    = true
}

variable "project_name" {
  description = "Short project name used in resource names and tags."
  type        = string
  default     = "eks-portfolio"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,29}$", var.project_name))
    error_message = "project_name must be 3-30 lowercase letters, digits, or hyphens and start with a letter."
  }
}

variable "environment" {
  description = "Environment name used in resource names and tags."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the VPC."
  type        = string
  default     = "10.20.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDRs, one per availability zone."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  validation {
    condition     = length(var.public_subnet_cidrs) == 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Exactly two valid public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDRs, one per availability zone."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
  validation {
    condition     = length(var.private_subnet_cidrs) == 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Exactly two valid private subnet CIDRs are required."
  }
}

variable "kubernetes_version" {
  description = "Supported Amazon EKS Kubernetes minor version. Confirm regional availability before applying."
  type        = string
  default     = "1.35"
  validation {
    condition     = can(regex("^1\\.[0-9]{2}$", var.kubernetes_version))
    error_message = "Use a Kubernetes minor version such as 1.35."
  }
}

variable "administrator_principal_arn" {
  description = "IAM role or user ARN granted cluster administrator access through an EKS access entry."
  type        = string
  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov|aws-cn):iam::[0-9]{12}:(role|user)/.+$", var.administrator_principal_arn))
    error_message = "Supply a valid IAM role or user ARN. STS assumed-role session ARNs are not accepted."
  }
}

variable "public_endpoint_access" {
  description = "Whether the EKS API is reachable from explicitly trusted public CIDRs. Private access is always enabled."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Trusted CIDRs allowed to reach the public EKS API endpoint. Required when public endpoint access is enabled."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.public_access_cidrs : can(cidrnetmask(cidr)) && cidr != "0.0.0.0/0"])
    error_message = "Every entry must be a valid CIDR; 0.0.0.0/0 is intentionally prohibited."
  }
}

variable "log_retention_days" {
  description = "CloudWatch retention for EKS control-plane logs."
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365], var.log_retention_days)
    error_message = "Choose a supported CloudWatch Logs retention period."
  }
}

variable "node_instance_types" {
  description = "EC2 instance types allowed for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_disk_size" {
  description = "Managed node root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "node_desired_size" {
  description = "Initial desired node count."
  type        = number
  default     = 2
}
variable "node_min_size" {
  description = "Minimum managed node count; this does not install Cluster Autoscaler."
  type        = number
  default     = 1
}
variable "node_max_size" {
  description = "Maximum managed node count; this does not install Cluster Autoscaler."
  type        = number
  default     = 3
}

variable "additional_tags" {
  description = "Additional tags merged with the required common tags."
  type        = map(string)
  default     = {}
}
