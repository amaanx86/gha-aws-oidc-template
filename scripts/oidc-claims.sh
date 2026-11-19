#!/usr/bin/env bash
# Prints the claims AWS checks from this job's GitHub OIDC token, never the token itself
# Runs inside a GitHub Actions job with permissions id-token: write
set -euo pipefail

: "${ACTIONS_ID_TOKEN_REQUEST_URL:?needs permissions id-token: write}"

token="$(curl -fsS -H "Authorization: bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" \
  "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=sts.amazonaws.com" | jq -r .value)"
echo "::add-mask::${token}"

payload="$(cut -d. -f2 <<<"$token" | tr '_-' '/+')"
while (( ${#payload} % 4 )); do payload+="="; done

base64 -d <<<"$payload" | jq '{iss, aud, sub, repository, ref, event_name}'
