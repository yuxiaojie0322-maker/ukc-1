#!/usr/bin/env bash
set -euo pipefail

UUID="${1:?UUID is required}"
FQDN="${2:?FQDN is required}"
ARGO_DOMAIN="${3:-}"

python3 - "$UUID" "$FQDN" "$ARGO_DOMAIN" <<'PY'
import sys

uuid, fqdn, argo_domain = sys.argv[1:4]
parts = fqdn.split(".")
metro = parts[-3].upper() if len(parts) >= 3 else "UKC"

label = f"UKC-{metro}-直连备用"
if metro == "SFO":
    label = f"UKC-SFO-直连【电信推荐】"

node = f"vless://{uuid}@{fqdn}:443?encryption=none&security=tls&sni={fqdn}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={fqdn}&path=%2F#{label}"
print(node)
PY
