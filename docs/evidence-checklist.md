# Evidence Checklist

Capture only genuine results after each authorized step. Do not substitute examples for evidence.

- [ ] `terraform fmt -check -recursive` output — capture after local validation
- [ ] `terraform validate` output — capture after provider initialization
- [ ] TFLint and IaC security scan output — capture when tools are installed
- [ ] Reviewed `terraform plan` summary — capture after authenticated plan
- [ ] Successful apply output — capture after authorized apply
- [ ] EKS cluster `ACTIVE` status — capture after deployment
- [ ] `kubectl get nodes -o wide` showing Ready nodes — capture after deployment
- [ ] Deployment rollout and two Ready pods — capture after application deployment
- [ ] Service and endpoints output — capture after application deployment
- [ ] Successful local port-forward response — capture after verification
- [ ] Application deletion output — capture during cleanup
- [ ] Terraform destroy output and post-cleanup resource checks — capture after authorized cleanup

