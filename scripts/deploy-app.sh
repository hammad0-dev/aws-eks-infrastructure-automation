#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUBECONFIG:=${root_dir}/.kube/config}"
export KUBECONFIG

[[ -f "${KUBECONFIG}" ]] || { echo "Missing ${KUBECONFIG}; run configure-kubeconfig.sh first." >&2; exit 1; }
kubectl apply -f "${root_dir}/kubernetes/namespace.yaml"
kubectl apply -f "${root_dir}/kubernetes/deployment.yaml"
kubectl apply -f "${root_dir}/kubernetes/service.yaml"
kubectl -n portfolio-app rollout status deployment/hello-app --timeout=180s

