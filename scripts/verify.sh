#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUBECONFIG:=${root_dir}/.kube/config}"
export KUBECONFIG

kubectl get nodes -o wide
kubectl -n portfolio-app get deployment,pods,service,endpoints -o wide
kubectl -n portfolio-app rollout status deployment/hello-app --timeout=180s

local_port="${LOCAL_PORT:-8080}"
kubectl -n portfolio-app port-forward service/hello-app "${local_port}:80" >/tmp/eks-portfolio-port-forward.log 2>&1 &
forward_pid=$!
trap 'kill "${forward_pid}" 2>/dev/null || true' EXIT
sleep 3
curl --fail --silent --show-error "http://127.0.0.1:${local_port}/" >/dev/null
echo "Application responded successfully through kubectl port-forward."

