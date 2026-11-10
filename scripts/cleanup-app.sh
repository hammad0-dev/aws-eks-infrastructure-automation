#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUBECONFIG:=${root_dir}/.kube/config}"
export KUBECONFIG

kubectl delete -f "${root_dir}/kubernetes/service.yaml" --ignore-not-found
kubectl delete -f "${root_dir}/kubernetes/deployment.yaml" --ignore-not-found
kubectl delete -f "${root_dir}/kubernetes/namespace.yaml" --ignore-not-found

