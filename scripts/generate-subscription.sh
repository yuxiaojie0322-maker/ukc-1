#!/usr/bin/env bash
set -euo pipefail

UUID="${1:?UUID is required}"
FQDN="${2:?FQDN is required}"
ARGO_DOMAIN="${3:-}"

if [[ -n "$ARGO_DOMAIN" ]]; then
  TEMPLATE="templates/sub.direct-tunnel.txt"
else
  TEMPLATE="templates/sub.direct.txt"
fi

python3 - "$UUID" "$FQDN" "$ARGO_DOMAIN" "$TEMPLATE" <<'PY'
import sys
from pathlib import Path

uuid, fqdn, argo_domain, template = sys.argv[1:5]
text = Path(template).read_text(encoding="utf-8")
text = text.replace("YOUR_UUID", uuid)
text = text.replace("xxx.sin.unikraft.app", fqdn)

parts = fqdn.split(".")
metro = parts[-3].upper() if len(parts) >= 3 else "UKC"
text = text.replace("#UKC-Unikraft", f"#UKC-{metro}")

if argo_domain:
    text = text.replace("ARGO_DOMAIN", argo_domain)
    text = text.replace("#UKC-Unikraft-Argo", f"#UKC-{metro}-Argo")

print(text.strip())
PY
