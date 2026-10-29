#!/bin/bash
# Encrypts checker/source.html into checker/index.html with StatiCrypt.
# The readable source stays out of git (.gitignore); only the encrypted page is published.
# The password comes from the login Keychain (service "helpdesktools-checker"), so builds need no typing.
# Store or change it once with:
#   security add-generic-password -U -a "$USER" -s helpdesktools-checker -w
# If it isn't stored, the script asks for it instead. .staticrypt.json holds the salt, which isn't secret.
set -euo pipefail
cd "$(dirname "$0")"

STATICRYPT_VERSION=3.5.4
KEYCHAIN_SERVICE=helpdesktools-checker

if pw="$(security find-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" -w 2>/dev/null)" && [[ -n "$pw" ]]; then
  echo "Using the password stored in the Keychain ($KEYCHAIN_SERVICE)."
else
  read -r -s -p "Password for the checker page: " pw; echo
  read -r -s -p "Same password again: " pw2; echo
  if [[ -z "$pw" || "$pw" != "$pw2" ]]; then
    echo "Passwords were empty or didn't match. Nothing built." >&2
    exit 1
  fi
fi

out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT

# --short: the password is a deliberate low-strength gate for a page holding nothing sensitive.
STATICRYPT_PASSWORD="$pw" npx -y "staticrypt@${STATICRYPT_VERSION}" checker/source.html \
  -d "$out" \
  --short \
  --remember 7 \
  --template-title "Connectivity check (prototype)" \
  --template-instructions "Enter the team password to open the connectivity check." \
  --template-button "Open" \
  --template-error "That password isn't right." \
  --template-color-primary "#1a1a1a" \
  --template-color-secondary "#f5f5f5"

mv "$out/source.html" checker/index.html
echo "Built checker/index.html. Commit and push it to publish."
