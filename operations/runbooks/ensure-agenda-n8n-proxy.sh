#!/usr/bin/env bash
set -euo pipefail

TARGET_CONF="${TARGET_CONF:-/home/deploy/portfolio_V3/nginx-proxy/data/nginx/proxy_host/5.conf}"
PROXY_CONTAINER="${PROXY_CONTAINER:-portfolio-proxy}"
BACKUP_DIR="${BACKUP_DIR:-/home/deploy/portfolio_V3/nginx-proxy/data/nginx/proxy_host/backups}"
QUIET="${QUIET:-0}"

log() {
  if [[ "$QUIET" != "1" ]]; then
    printf '%s\n' "$1"
  fi
}

if [[ ! -f "$TARGET_CONF" ]]; then
  echo "Target config not found: $TARGET_CONF" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"

TMP_FILE="$(mktemp)"
python3 - "$TARGET_CONF" "$TMP_FILE" <<'PY'
from pathlib import Path
import re
import sys

target_path = Path(sys.argv[1])
tmp_path = Path(sys.argv[2])
text = target_path.read_text(encoding="utf-8")

managed_begin = "  # BEGIN agenda-n8n managed block"
managed_end = "  # END agenda-n8n managed block"
managed_block = """  # BEGIN agenda-n8n managed block
  location = /agenda-n8n {
    return 301 /agenda-n8n/;
  }

  location = /agenda-n8n/webhook {
    return 301 /agenda-n8n/webhook/;
  }

  location = /agenda-n8n/webhook-test {
    return 301 /agenda-n8n/webhook-test/;
  }

  location ^~ /agenda-n8n/webhook/ {
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Scheme $scheme;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_http_version 1.1;
    proxy_pass http://agenda-n8n:5678/webhook/;
  }

  location ^~ /agenda-n8n/webhook-test/ {
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Scheme $scheme;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_http_version 1.1;
    proxy_pass http://agenda-n8n:5678/webhook-test/;
  }

  location ^~ /agenda-n8n/ {
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Scheme $scheme;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_http_version 1.1;
    proxy_pass http://agenda-n8n:5678/;
  }
  # END agenda-n8n managed block
"""

managed_pattern = re.compile(
    r"\n\s*# BEGIN agenda-n8n managed block.*?# END agenda-n8n managed block\n",
    re.S,
)
text = managed_pattern.sub("\n", text)

legacy_pattern = re.compile(
    r"\n\s*location = /agenda-n8n \{\n.*?\n\s*location \^~ /agenda-n8n/ \{\n.*?\n\s*\}\n",
    re.S,
)
text = legacy_pattern.sub("\n", text, count=1)

anchor = "  location / {\n"
if anchor not in text:
    raise SystemExit("Anchor location / block not found in target config")

text = text.replace(anchor, managed_block + "\n\n" + anchor, 1)
tmp_path.write_text(text, encoding="utf-8")
PY

if cmp -s "$TARGET_CONF" "$TMP_FILE"; then
  log "agenda-n8n proxy config already up to date"
  rm -f "$TMP_FILE"
  exit 0
fi

cp "$TARGET_CONF" "$BACKUP_DIR/5.conf.$(date +%Y%m%d%H%M%S).bak"
cp "$TMP_FILE" "$TARGET_CONF"
rm -f "$TMP_FILE"

docker exec "$PROXY_CONTAINER" nginx -t
docker exec "$PROXY_CONTAINER" nginx -s reload
log "agenda-n8n proxy config updated and nginx reloaded"
