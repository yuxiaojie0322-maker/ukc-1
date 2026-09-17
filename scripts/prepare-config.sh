#!/usr/bin/env bash
set -euo pipefail

UUID="${1:?UUID is required}"
ARGO_DOMAIN="${2:-}"
ARGO_TOKEN="${3:-}"

if [[ -n "$ARGO_DOMAIN" || -n "$ARGO_TOKEN" ]]; then
  if [[ -z "$ARGO_DOMAIN" || -z "$ARGO_TOKEN" ]]; then
    echo "ARGO_DOMAIN and ARGO_TOKEN must both be set or both omitted" >&2
    exit 1
  fi
  cp templates/config.direct-tunnel.json templates/config.json
else
  cp templates/config.direct.json templates/config.json
fi

python3 - "$UUID" "$ARGO_TOKEN" <<'PY'
import json
import sys
from pathlib import Path

uuid, argo_token = sys.argv[1], sys.argv[2]
path = Path("templates/config.json")
data = json.loads(path.read_text(encoding="utf-8"))

def replace(obj):
    if isinstance(obj, dict):
        return {k: replace(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [replace(v) for v in obj]
    if isinstance(obj, str):
        if obj == "YOUR_UUID":
            return uuid
        if obj == "YOUR_TOKEN" and argo_token:
            return argo_token
        return obj
    return obj

path.write_text(json.dumps(replace(data), indent=2) + "\n", encoding="utf-8")
PY

echo "Prepared templates/config.json"
