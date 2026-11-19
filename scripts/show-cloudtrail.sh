#!/usr/bin/env bash
# Usage: scripts/show-cloudtrail.sh [role-name] [hours-back]
# CloudTrail lags 5 to 15 minutes, so query an earlier pipeline run
set -euo pipefail

role_name="${1:-gha-deploy}"
hours_back="${2:-24}"
region="${AWS_REGION:-eu-west-3}"

if ! command -v jq >/dev/null; then
  echo "jq is required" >&2
  exit 1
fi

start_time="$(date -u -v-"${hours_back}"H +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
  || date -u -d "-${hours_back} hours" +%Y-%m-%dT%H:%M:%SZ)"

aws cloudtrail lookup-events \
  --region "$region" \
  --start-time "$start_time" \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRoleWithWebIdentity \
  --max-results 50 \
  --query 'Events[].CloudTrailEvent' \
  --output json \
  | jq -r --arg role "$role_name" '
      map(fromjson)
      | map(select((.requestParameters.roleArn // "") | endswith(":role/" + $role)))
      | if length == 0 then "No events for role \($role) since the start time." else
          (["TIME", "RESULT", "SUBJECT (sub claim)", "SESSION"] | @tsv),
          (.[] | [
            .eventTime,
            (.errorCode // "ALLOWED"),
            .userIdentity.userName,
            (.requestParameters.roleSessionName // "-")
          ] | @tsv)
        end
    ' \
  | column -t -s $'\t'
