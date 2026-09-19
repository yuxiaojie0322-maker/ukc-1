#!/usr/bin/env bash
# Encrypt subscription text with AES-256-CBC; key derived from UUID (SHA-256).
# Output: https://vevc.github.io/unikraft-deploy/?payload=<url-encoded IV:base64-ciphertext>
set -euo pipefail

UUID="${1:?UUID is required}"
PLAINTEXT="${2:?Plaintext subscription is required}"

KEY="$(printf '%s' "$UUID" | openssl dgst -sha256 -binary | xxd -p -c 32)"
IV="$(openssl rand -hex 16)"
CIPHERTEXT="$(printf '%s' "$PLAINTEXT" | openssl enc -aes-256-cbc -K "$KEY" -iv "$IV" | openssl base64 -A)"
PAYLOAD="${IV}:${CIPHERTEXT}"
ENCODED="$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$PAYLOAD")"

echo "https://vevc.github.io/unikraft-deploy/?payload=${ENCODED}"
