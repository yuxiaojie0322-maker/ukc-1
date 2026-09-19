#!/usr/bin/env bash
set -euo pipefail

UUID="${1:?UUID is required}"
ARGO_DOMAIN="${2:-}"
ARGO_TOKEN="${3:-}"

python3 scripts/prepare-config.py "$UUID" "$ARGO_DOMAIN" "$ARGO_TOKEN"
