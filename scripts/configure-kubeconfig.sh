#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubeconfig="${KUBECONFIG:-${root_dir}/.kube/config}"
cluster_name="${CLUSTER_NAME:-$(terraform -chdir="${root_dir}/terraform" output -raw cluster_name)}"
region="${AWS_REGION:-$(terraform -chdir="${root_dir}/terraform" output -raw aws_region)}"

mkdir -p "$(dirname "${kubeconfig}")"
args=(eks update-kubeconfig --name "${cluster_name}" --region "${region}" --kubeconfig "${kubeconfig}" --alias "${cluster_name}")
if [[ -n "${AWS_PROFILE:-}" ]]; then
  args+=(--profile "${AWS_PROFILE}")
fi
aws "${args[@]}"
printf 'Dedicated kubeconfig updated: %s\nExport with: export KUBECONFIG=%q\n' "${kubeconfig}" "${kubeconfig}"

