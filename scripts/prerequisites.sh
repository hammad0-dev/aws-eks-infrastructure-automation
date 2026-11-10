#!/usr/bin/env bash
set -euo pipefail

required=(terraform aws kubectl)
optional=(git docker tflint trivy shellcheck kubeconform)
missing=0

for command_name in "${required[@]}"; do
  if command -v "${command_name}" >/dev/null 2>&1; then
    printf 'OK       %-12s %s\n' "${command_name}" "$(command -v "${command_name}")"
  else
    printf 'MISSING  %-12s required\n' "${command_name}" >&2
    missing=1
  fi
done

for command_name in "${optional[@]}"; do
  if command -v "${command_name}" >/dev/null 2>&1; then
    printf 'OK       %-12s %s\n' "${command_name}" "$(command -v "${command_name}")"
  else
    printf 'OPTIONAL %-12s not installed\n' "${command_name}"
  fi
done

if (( missing != 0 )); then
  echo "Install missing required tools before deployment." >&2
  exit 1
fi

