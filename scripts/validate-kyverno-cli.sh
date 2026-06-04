#!/usr/bin/env bash
# Validate manifests against Kyverno policies using the kyverno CLI (no cluster needed).
# Usage: ./scripts/validate-kyverno-cli.sh <policies-dir> <manifests-dir>
# Requires: kyverno CLI installed (brew install kyverno)

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <policies-dir> <manifests-dir>"
  echo ""
  echo "Examples:"
  echo "  $0 modules/03-kyverno/policies/ modules/03-kyverno/manifests/bad/"
  echo "  $0 modules/03-kyverno/policies/ modules/03-kyverno/manifests/good/"
  exit 1
fi

POLICIES_DIR="$1"
MANIFESTS_DIR="$2"

if ! command -v kyverno &> /dev/null; then
  echo "Error: kyverno CLI not found. Install with: brew install kyverno"
  exit 1
fi

echo "Policies : $POLICIES_DIR"
echo "Manifests: $MANIFESTS_DIR"
echo ""

kyverno apply "$POLICIES_DIR" --resource "$MANIFESTS_DIR"
