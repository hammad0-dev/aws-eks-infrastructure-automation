# Cost and Cleanup

Pricing changes by region and date. Before applying, use the official [EKS pricing](https://aws.amazon.com/eks/pricing/), [EC2 On-Demand pricing](https://aws.amazon.com/ec2/pricing/on-demand/), [EBS pricing](https://aws.amazon.com/ebs/pricing/), [VPC pricing](https://aws.amazon.com/vpc/pricing/), and [CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/) pages or AWS Pricing Calculator for the selected region.

For the default `us-east-1` design, estimate one standard-support EKS cluster, two `t3.medium` On-Demand nodes, two 20-GiB node volumes, one NAT gateway, one NAT Elastic IP/public IPv4, control-plane logs, and data transfer. NAT is billed per gateway-hour and per processed GB; public IPv4 addresses are billed hourly. Cross-AZ traffic can apply because the second private subnet uses the first AZ's NAT. Numerical totals are intentionally omitted until checked immediately before deployment.

Cleanup order is application, reviewed Terraform destroy plan, then authorized destroy. Afterward check project tags and billing/resource explorers for load balancers, target groups, NAT gateways, EIPs, EC2 instances, EBS volumes/snapshots, ENIs, security groups, CloudWatch logs, and S3 objects. Kubernetes-created cloud resources can outlive Terraform if their controllers or finalizers did not clean them up first.

