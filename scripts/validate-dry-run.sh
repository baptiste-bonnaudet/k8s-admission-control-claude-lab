#!/usr/bin/env bash
# Validate a manifest against a live cluster using server-side dry-run.
# Usage: ./scripts/validate-dry-run.sh <manifest-file>
# The manifest must specify a namespace that exists on the cluster.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <manifest-file>"
  exit 1
fi

MANIFEST="$1"

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: file not found: $MANIFEST"
  exit 1
fi

echo "Validating: $MANIFEST"
kubectl apply --dry-run=server -f "$MANIFEST"
