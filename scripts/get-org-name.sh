#!/usr/bin/env bash
set -euo pipefail

# After `unikraft login`, organization is stored in the active profile config.
# `unikraft profile get -o json` does not expose organization, so read config.yaml.

CONFIG="${UNIKRAFT_CONFIG:-$HOME/.config/unikraft/config.yaml}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Unikraft config not found: $CONFIG" >&2
  echo "Login first: echo \"\$UNIKRAFT_TOKEN\" | unikraft login --token -" >&2
  exit 1
fi

ORG="$(python3 - "$CONFIG" <<'PY'
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

if yaml is not None:
    cfg = yaml.safe_load(text) or {}
    profile = cfg.get("profile", "default")
    profiles = cfg.get("profiles") or {}
    entry = profiles.get(profile) or {}
    print(entry.get("organization", "") or "")
else:
    active = "default"
    in_profiles = False
    current = None
    org = ""
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("profile:"):
            active = stripped.split(":", 1)[1].strip()
            continue
        if stripped == "profiles:":
            in_profiles = True
            continue
        if in_profiles and not line.startswith(" ") and stripped.endswith(":"):
            break
        if in_profiles and stripped.endswith(":") and line.startswith("  ") and not line.startswith("    "):
            current = stripped[:-1]
            continue
        if current == active and stripped.startswith("organization:"):
            org = stripped.split(":", 1)[1].strip()
            break
    print(org)
PY
)"

if [[ -z "$ORG" || "$ORG" == "null" ]]; then
  ORG="${UKC_ORG:-${ORGANIZATION:-xiaojieyu}}"
  echo "$ORG"
  exit 0
fi

echo "$ORG"
