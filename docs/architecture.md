# Architecture

The VPC spans the first two available AZs in the selected region. Each AZ has one public and one private subnet. Public route tables send `0.0.0.0/0` to the internet gateway. Each private route table sends `0.0.0.0/0` to one NAT gateway in public subnet 1. DNS support and hostnames are enabled.

Public subnets carry `kubernetes.io/role/elb=1`; private subnets carry `kubernetes.io/role/internal-elb=1`. Cluster ownership tags are `shared`. No load balancer controller is installed and the sample Service is ClusterIP, so these tags only prepare for an optional future integration.

EKS places control-plane network interfaces across the supplied public and private subnet set. Managed AL2023 nodes launch only in private subnets. The cluster uses API-only access entries and grants the explicit operator principal `AmazonEKSClusterAdminPolicy`. The EKS API private endpoint is enabled. A public endpoint is optional and must be CIDR restricted.

The managed add-ons are VPC CNI, CoreDNS, and kube-proxy. Omitting `addon_version` asks EKS to select a compatible default for the cluster version, avoiding a region-specific version baked into source. Confirm versions in the reviewed plan or with `aws eks describe-addon-versions` before apply.

One NAT is cheaper than one per AZ but introduces a single-AZ egress dependency. AZ2 node egress can cross AZ1, creating data-transfer cost. A resilient design normally uses one NAT per AZ. A no-NAT design needs appropriate endpoints (commonly ECR API/DKR, S3, EC2, STS, EKS, logs, and others required by workloads) plus DNS and security-group design; it is not a simple route deletion.

