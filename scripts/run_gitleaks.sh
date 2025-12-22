#!/bin/bash
set -e

REPORT_JSON="gitleaks-report.json"
REPORT_MD="gitleaks-report.md"
MAX_GITHUB_LEVELS_DEFAULT=-100

{
  echo "### 🛡️ Gitleaks Report"
  echo "<img alt='gitleaks badge' src='https://img.shields.io/badge/protected%20by-gitleaks-blue'>"
  echo ""
} >> "$GITHUB_STEP_SUMMARY"

if [[ -z "$MAX_GITHUB_LEVELS" ]]; then
  {
    echo "##### MAX_GITHUB_LEVELS is not defined. Using $MAX_GITHUB_LEVELS_DEFAULT as default value"
  } >> "$GITHUB_STEP_SUMMARY"
  MAX_GITHUB_LEVELS=$MAX_GITHUB_LEVELS_DEFAULT
else
  {
    echo "##### MAX_GITHUB_LEVELS has been defined as ${MAX_GITHUB_LEVELS}"
  } >> "$GITHUB_STEP_SUMMARY"
fi

docker run \
  -v "$(pwd):/path" \
  ghcr.io/gitleaks/gitleaks:latest \
  detect \
  --source=/path \
  --report-path=/path/$REPORT_JSON \
  --verbose \
  --log-opts="${MAX_GITHUB_LEVELS}" \
  --exit-code=0

./convert_gitleaks_json_to_md.sh "$REPORT_JSON" "$REPORT_MD"

{
  echo ""
  cat "$REPORT_MD"
  echo ""
  echo "| icon | Artifacts | format |"
  echo "|------|----------|--------|"
  echo "|📄| **gitleaks-report-md** | **md** |"
  echo "|🛠️| **gitleaks-report-json** | **json** |"
} >> "$GITHUB_STEP_SUMMARY"

./display_message.sh "$(jq '. | length' "$REPORT_JSON")"
./display_elapsed.sh

{
  echo "---"
  echo "##### NEXT ➡️"
} >> "$GITHUB_STEP_SUMMARY"