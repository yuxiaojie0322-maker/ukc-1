#!/usr/bin/env bash
set -euo pipefail

UUID="${1:?UUID is required}"
ARGO_DOMAIN="${2:?ARGO_DOMAIN is required}"

python3 - "$UUID" "$ARGO_DOMAIN" <<'PY'
import sys

uuid, argo_domain = sys.argv[1:3]

nodes = [
    f"vless://{uuid}@{argo_domain}:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-默认Anycast",
    f"vless://{uuid}@cf.090227.xyz:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选CNAME-090227",
    f"vless://{uuid}@ct.v6.rocks:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选CNAME-v6",
    f"vless://{uuid}@cloudflare.cfgo.cc:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选CNAME-cfgo",
    f"vless://{uuid}@104.16.160.1:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选IP-104.16",
    f"vless://{uuid}@162.159.192.1:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选IP-162.159",
    f"vless://{uuid}@104.28.160.1:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选IP-104.28",
    f"vless://{uuid}@172.64.0.1:443?encryption=none&security=tls&sni={argo_domain}&fp=chrome&insecure=0&allowInsecure=0&type=ws&host={argo_domain}&path=%2F#UKC-Argo-电信优选IP-172.64"
]

print("\n".join(nodes))
PY
