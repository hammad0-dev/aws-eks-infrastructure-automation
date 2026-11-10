# Troubleshooting

## Pending Pods

Run `kubectl describe pod -n portfolio-app POD` and inspect events. Check node readiness, requests versus allocatable CPU/memory, taints, selectors, subnet IP exhaustion, and scheduler messages. Node group min/max values do not deploy an autoscaler.

## ImagePullBackOff

Use `kubectl describe pod` to inspect registry errors. Verify the tag exists, NAT/DNS connectivity works, the registry is reachable, and no rate limit applies. For ECR images, also check the node or pod identity permissions.

## Nodes Fail to Join

Inspect the node group health issues, EC2 console output, EKS control-plane logs, IAM attachments, subnet routes/NAT, security groups, DNS, available IPs, quotas, and instance capacity. Try multiple suitable instance types if capacity is constrained.

## Access Denied or kubectl Timeout

Confirm `aws sts get-caller-identity` matches `administrator_principal_arn`, regenerate the dedicated kubeconfig, and inspect the EKS access entry/policy association. IAM permissions to call AWS APIs are different from Kubernetes permissions. A timeout generally indicates endpoint CIDR or private-network reachability, not RBAC.

## Terraform

Provider download failures indicate network/proxy/DNS restrictions. Authentication failures require a valid AWS credential chain. Region-specific unsupported EKS versions or instance capacity appear during planning/apply. Never edit state manually; back it up and use Terraform state commands deliberately.

