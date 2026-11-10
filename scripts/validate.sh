#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
terraform_dir="${root_dir}/terraform"

terraform -chdir="${terraform_dir}" fmt -check -recursive
terraform -chdir="${terraform_dir}" init -backend=false
terraform -chdir="${terraform_dir}" validate

if command -v tflint >/dev/null 2>&1; then
  tflint --chdir="${terraform_dir}" --init
  tflint --chdir="${terraform_dir}" --recursive
else
  echo "SKIP: tflint is not installed."
fi

if command -v trivy >/dev/null 2>&1; then
  trivy config --exit-code 1 "${terraform_dir}"
else
  echo "SKIP: Trivy is not installed."
fi

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${root_dir}"/scripts/*.sh
else
  echo "SKIP: ShellCheck is not installed."
fi

if command -v kubeconform >/dev/null 2>&1; then
  kubeconform -strict -summary "${root_dir}"/kubernetes/*.yaml
else
  echo "SKIP: kubeconform is not installed."
fi

