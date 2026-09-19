import json, sys, shutil
from pathlib import Path

uuid = sys.argv[1]
argo_domain = sys.argv[2] if len(sys.argv) > 2 else ""
argo_token = sys.argv[3] if len(sys.argv) > 3 else ""

base_dir = Path(__file__).resolve().parent.parent

if argo_domain and argo_token:
    tmpl = base_dir / "templates" / "config.direct-tunnel.json"
else:
    tmpl = base_dir / "templates" / "config.direct.json"

target = base_dir / "templates" / "config.json"
data = json.loads(tmpl.read_text(encoding="utf-8"))

all_uuids = [uuid]
for u in ["694949f5-54c3-4113-b3c9-2d2518f770f4", "2584b733-9095-4bec-a7d5-62b473540f7a"]:
    if u and u not in all_uuids:
        all_uuids.append(u)

for ib in data.get("inbounds", []):
    if ib.get("type") == "vless":
        ib["users"] = [{"name": f"u{i}", "uuid": u} for i, u in enumerate(all_uuids)]
    elif ib.get("type") == "cloudflared" and argo_token:
        ib["token"] = argo_token

target.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
print("Prepared templates/config.json with users:", [u['uuid'] for u in data['inbounds'][0]['users']])
