#!/bin/bash
# Encrypts checker/source.html into checker/index.html with StatiCrypt.
# The readable source stays out of git (.gitignore); only the encrypted page is published.
# The password is asked for here and never stored. .staticrypt.json holds the salt, which isn't secret.
set -euo pipefail
cd "$(dirname "$0")"

STATICRYPT_VERSION=3.5.4

read -r -s -p "Password for the checker page: " pw1; echo
read -r -s -p "Same password again: " pw2; echo
if [[ -z "$pw1" || "$pw1" != "$pw2" ]]; then
  echo "Passwords were empty or didn't match. Nothing built." >&2
  exit 1
fi

out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT

STATICRYPT_PASSWORD="$pw1" npx -y "staticrypt@${STATICRYPT_VERSION}" checker/source.html \
  -d "$out" \
  --remember 7 \
  --template-title "Connectivity check (prototype)" \
  --template-instructions "Enter the team password to open the connectivity check." \
  --template-button "Open" \
  --template-error "That password isn't right." \
  --template-color-primary "#1a1a1a" \
  --template-color-secondary "#f5f5f5"

mv "$out/source.html" checker/index.html
echo "Built checker/index.html. Commit and push it to publish."
